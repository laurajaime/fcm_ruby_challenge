class ItineraryService
  TRANSPORT_TYPES = %w[Flight Train].freeze

  def initialize(based, raw_itinerary_path)
    @based = based
    @raw_itinerary = read_raw_itinerary(raw_itinerary_path)
  end

  attr_reader :based, :raw_itinerary

  def humanify
    ActiveRecord::Base.transaction do
      if Itinerary.where(based_iata: based, raw_content: raw_itinerary).empty?
        itinerary = persist_itinerary
        persist_segments(itinerary)

        segments = itinerary.segments
      else
        segments = Itinerary.find_by(based_iata: based, raw_content: raw_itinerary).segments
      end
      # Order segments by from_date, from_time and segment_type because we want to print the itinerary in order
      # taking into account the time of the fligths or trains and hotels
      
      # syntax for postgresql is more simple but we need to support sqlite
      # ordered_segments = Segment.order(:from_date, :from_time, :segment_type)
      # specific syntaxes for sqlite because of the lack of support for NULLS FIRST and NULLS LAST
      ordered_segments = segments.order(
        Arel.sql("CASE WHEN from_date IS NULL THEN 1 ELSE 0 END, from_date ASC"),
        Arel.sql("CASE WHEN from_time IS NULL THEN 1 ELSE 0 END, from_time ASC"),
        :segment_type)

      print_itinerary(ordered_segments)
    rescue StandardError => e
      puts "Error humanifying itinerary: #{e}"
    rescue ActiveRecord::RecordInvalid => e
      puts "Error saving segments: #{e}"
    end
  end

  private

  def start_of_trip?(segment)
    segment.from == based
  end

  def end_of_trip?(segment)
    segment.to == based
  end

  def is_a_connection?(segment, next_segment)
    segment.to == next_segment.from
  end

  def is_the_last_segment?(segment, next_segment)
    next_segment.nil? || segment.to == next_segment.to
  end

  def read_raw_itinerary(raw_itinerary_path)
    File.read(raw_itinerary_path)
  end
  
  def print_itinerary(segments)
    segments.each_with_index do |segment, index|
      presenter = SegmentPresenter.new(segment)
      next_segment = index < segments.size - 1 ? segments[index + 1] : nil

      if start_of_trip?(segment)
        puts "TRIP to #{next_segment&.to || segment.to}"
      end

      case segment.segment_type
      when 'Hotel'
        puts presenter.hotel_human_segment
      when *TRANSPORT_TYPES
        puts presenter.trip_human_segment
      end

      puts "\n" if end_of_trip?(segment) && !is_the_last_segment?(segment, next_segment)
    end
  end

  def persist_itinerary
    Itinerary.create!(based_iata: based, raw_content: raw_itinerary)
  end

  def persist_segments(itinerary)
    reservations = raw_itinerary.split("\n\n").map do |reservation|
      reservation_info = reservation.split("\n")
      reservation_info.each do |line|
        next unless line.start_with?("SEGMENT:")

        segment_params = extract_segment(line)
        Segment.create!(segment_params.merge(itinerary: itinerary))
      end
    end
  end

  def extract_segment(line)
    raw_segment = line.split(" ")
    attrs = {}

    # That asumes that the segments has always the following format:
    # ["SEGMENT:", "Flight", "SVQ", "2023-03-02", "06:40", "->", "BCN", "09:10"]
    if raw_segment[1].in?(TRANSPORT_TYPES)
      attrs = {
        segment_type: raw_segment[1],
        from: raw_segment[2],
        from_date: raw_segment[3],
        from_time: raw_segment[4],
        to: raw_segment[6],
        to_time: raw_segment[7],
      }
    else
      attrs = {
        segment_type: raw_segment[1],
        on: raw_segment[2],
        from_date: raw_segment[3],
        to_date: raw_segment[5],
      }
    end
    
    attrs
  end
end
