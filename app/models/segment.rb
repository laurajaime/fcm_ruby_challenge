# frozen_string_literal: true

class Segment < ApplicationRecord
  TRANSPORT_TYPES = %w[Flight Train].freeze

  belongs_to :itinerary

  def a_hotel?
    segment_type == 'Hotel'
  end

  def a_transport?
    segment_type.in?(TRANSPORT_TYPES)
  end
end
