# frozen_string_literal: true

FactoryBot.define do
  factory :segment do
    association :itinerary
  end
end
