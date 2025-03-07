# frozen_string_literal: true

namespace :itinerary do
  desc 'Humanify itinerary. args -> based: SVQ, raw_itinerary_path: tmp/raw_itinerary.txt'
  task :humanify, %i[based raw_itinerary_path] => :environment do |_task, args|
    ItineraryService.new(args[:based], args[:raw_itinerary_path]).humanify
  end
end
