# frozen_string_literal: true

class SegmentPresenter
  def initialize(segment)
    @segment = segment
  end

  attr_reader :segment

  def formatted_trip_title(next_segment)
    "TRIP to #{next_segment&.to || segment.to}"
  end

  def formatted_trip_info
    if segment.a_hotel?
      formatted_hotel_segment
    elsif segment.a_transport?
      formatted_trip_segment
    end
  end

  private

  def parse_time(time)
    time.strftime('%H:%M')
  end

  def formatted_hotel_segment
    "#{segment.segment_type} at #{segment.on} on #{segment.from_date} to #{segment.to_date}"
  end

  def formatted_trip_segment
    "#{segment.segment_type} from #{segment.from} to #{segment.to} at #{segment.from_date} #{parse_time(segment.from_time)} to #{parse_time(segment.to_time)}"
  end
end
