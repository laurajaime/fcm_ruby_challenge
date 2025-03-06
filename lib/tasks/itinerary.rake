# llama al service y printa el resultado
namespace :itinerary do
  desc "Humanify itinerary. args -> based: SVQ, raw_itinerary_path: tmp/raw_itinerary.txt"
  task :humanify, [:based, :raw_itinerary_path] => :environment do |task, args|
    ItineraryService.new(args[:based], args[:raw_itinerary_path]).humanify
  end
end
