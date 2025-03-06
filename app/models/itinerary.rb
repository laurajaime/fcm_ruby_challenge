class Itinerary < ApplicationRecord
  has_many :segments, dependent: :destroy
end
