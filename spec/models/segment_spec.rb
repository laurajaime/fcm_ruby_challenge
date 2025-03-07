require 'rails_helper'

describe Segment, type: :model do
  describe '#is_a_hotel?' do
    let(:itinerary) { create(:itinerary) }
    let(:segment) { create(:segment, segment_type: 'Hotel', on: "BCN", from_date: '2023-01-05', to_date: '2023-01-10', itinerary: itinerary) }

    it 'returns true' do
      expect(segment.is_a_hotel?).to eq(true)
    end
  end

  describe '#is_a_transport?' do
    let(:itinerary) { create(:itinerary) }
    let(:segment) { create(:segment, segment_type: 'Train', to: "BCN", from_time: '09:30', to_time: '11:00', from_date: '2023-02-15', to_date: '2023-02-15', itinerary: itinerary) }

    it 'returns true' do
      expect(segment.is_a_transport?).to eq(true)
    end
  end
end
