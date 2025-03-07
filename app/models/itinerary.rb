# frozen_string_literal: true

class Itinerary < ApplicationRecord
  has_many :segments, dependent: :destroy
end
