class SegmentPresenter
  def initialize(segment)
    @segment = segment
  end

  attr_reader :segment

  def formatted_hotel_segment
    "#{segment.segment_type} at #{segment.on} on #{segment.from_date} to #{segment.to_date}"
  end

  def formatter_trip_segment
    "#{segment.segment_type} from #{segment.from} to #{segment.to} at #{segment.from_date} #{parse_time(segment.from_time)} to #{parse_time(segment.to_time)}"
  end

  private

  def parse_time(time)
    time.strftime("%H:%M")
  end
end
