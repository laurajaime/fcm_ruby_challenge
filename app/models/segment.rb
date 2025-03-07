class Segment < ApplicationRecord
  TRANSPORT_TYPES = %w[Flight Train].freeze

  belongs_to :itinerary

  def is_a_hotel?
    segment_type == "Hotel"
  end

  def is_a_transport?
    segment_type.in?(TRANSPORT_TYPES)
  end
end
