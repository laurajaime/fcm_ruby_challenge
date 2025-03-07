# frozen_string_literal: true

require 'rails_helper'

describe Segment, type: :model do
  describe '#a_hotel?' do
    let(:itinerary) { create(:itinerary) }
    let(:segment) do
      create(:segment, segment_type: 'Hotel', on: 'BCN', from_date: '2023-01-05', to_date: '2023-01-10',
                       itinerary: itinerary)
    end

    it 'returns true' do
      expect(segment.a_hotel?).to eq(true)
    end
  end

  describe '#a_transport?' do
    let(:itinerary) { create(:itinerary) }
    let(:segment) do
      create(:segment, segment_type: 'Train', to: 'BCN', from_time: '09:30', to_time: '11:00', from_date: '2023-02-15',
                       to_date: '2023-02-15', itinerary: itinerary)
    end

    it 'returns true' do
      expect(segment.a_transport?).to eq(true)
    end
  end
end
