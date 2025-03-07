# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
describe ItineraryService, type: :service do
  before do
    allow(File).to receive(:read).and_return(raw_itinerary_content)
  end

  describe '#humanify' do
    context 'when based is SVQ' do
      let(:raw_itinerary_content) do
        <<~RAW
          RESERVATION
          SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

          RESERVATION
          SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

          RESERVATION
          SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
          SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

          RESERVATION
          SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
          SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

          RESERVATION
          SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

          RESERVATION
          SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
        RAW
      end

      context 'when itinerary not exists' do
        let(:based) { 'SVQ' }
        let(:service) { ItineraryService.new(based, raw_itinerary_content) }

        it 'persist the itinerary' do
          expect { service.humanify }.to change { Itinerary.count }.by(1)
        end

        it 'persist the segments' do
          expect { service.humanify }.to change { Segment.count }.by(8)
        end

        it 'prints the correct itinerary' do
          expect { service.humanify }.to output(
            <<~OUTPUT
              TRIP to BCN
              Flight from SVQ to BCN at 2023-01-05 20:40 to 22:10
              Hotel at BCN on 2023-01-05 to 2023-01-10
              Flight from BCN to SVQ at 2023-01-10 10:30 to 11:50

              TRIP to MAD
              Train from SVQ to MAD at 2023-02-15 09:30 to 11:00
              Hotel at MAD on 2023-02-15 to 2023-02-17
              Train from MAD to SVQ at 2023-02-17 17:00 to 19:30

              TRIP to NYC
              Flight from SVQ to BCN at 2023-03-02 06:40 to 09:10
              Flight from BCN to NYC at 2023-03-02 15:00 to 22:45
            OUTPUT
          ).to_stdout
        end
      end

      context 'when itinerary exists' do
        let(:based) { 'SVQ' }
        let(:itinerary) { create(:itinerary, based_iata: based, raw_content: raw_itinerary_content) }
        let!(:segments) do
          [
            create(:segment, segment_type: 'Flight', from: 'SVQ', from_date: '2023-03-02', from_time: '06:40',
                             to: 'BCN', to_time: '09:10', itinerary: itinerary),
            create(:segment, segment_type: 'Hotel', on: 'BCN', from_date: '2023-01-05', to_date: '2023-01-10',
                             itinerary: itinerary),
            create(:segment, segment_type: 'Flight', from: 'SVQ', from_date: '2023-01-05', from_time: '20:40',
                             to: 'BCN', to_time: '22:10', itinerary: itinerary),
            create(:segment, segment_type: 'Flight', from: 'BCN', from_date: '2023-01-10', from_time: '10:30',
                             to: 'SVQ', to_time: '11:50', itinerary: itinerary),
            create(:segment, segment_type: 'Train', from: 'SVQ', from_date: '2023-02-15', from_time: '09:30',
                             to: 'MAD', to_time: '11:00', itinerary: itinerary),
            create(:segment, segment_type: 'Train', from: 'MAD', from_date: '2023-02-17', from_time: '17:00',
                             to: 'SVQ', to_time: '19:30', itinerary: itinerary),
            create(:segment, segment_type: 'Hotel', on: 'MAD', from_date: '2023-02-15', to_date: '2023-02-17',
                             itinerary: itinerary),
            create(:segment, segment_type: 'Flight', from: 'BCN', from_date: '2023-03-02', from_time: '15:00',
                             to: 'NYC', to_time: '22:45', itinerary: itinerary)
          ]
        end
        let(:service) { ItineraryService.new(based, raw_itinerary_content) }

        it 'prints the correct itinerary' do
          expect { service.humanify }.to output(
            <<~OUTPUT
              TRIP to BCN
              Flight from SVQ to BCN at 2023-01-05 20:40 to 22:10
              Hotel at BCN on 2023-01-05 to 2023-01-10
              Flight from BCN to SVQ at 2023-01-10 10:30 to 11:50

              TRIP to MAD
              Train from SVQ to MAD at 2023-02-15 09:30 to 11:00
              Hotel at MAD on 2023-02-15 to 2023-02-17
              Train from MAD to SVQ at 2023-02-17 17:00 to 19:30

              TRIP to NYC
              Flight from SVQ to BCN at 2023-03-02 06:40 to 09:10
              Flight from BCN to NYC at 2023-03-02 15:00 to 22:45
            OUTPUT
          ).to_stdout
        end
      end

      context 'when based is BCN' do
        let(:raw_itinerary_content) do
          <<~RAW
            RESERVATION
            SEGMENT: Hotel SQV 2023-01-05 -> 2023-01-10

            RESERVATION
            SEGMENT: Flight BCN 2023-01-05 20:40 -> SQV 22:10
            SEGMENT: Flight SQV 2023-01-10 10:30 -> BCN 11:50
          RAW
        end

        context 'when itinerary not exists' do
          let(:based) { 'BCN' }
          let(:service) { ItineraryService.new(based, raw_itinerary_content) }

          it 'persist the itinerary' do
            expect { service.humanify }.to change { Itinerary.count }.by(1)
          end

          it 'persist the segments' do
            expect { service.humanify }.to change { Segment.count }.by(3)
          end

          it 'prints the correct itinerary' do
            expect { service.humanify }.to output(
              <<~OUTPUT
                TRIP to SQV
                Flight from BCN to SQV at 2023-01-05 20:40 to 22:10
                Hotel at SQV on 2023-01-05 to 2023-01-10
                Flight from SQV to BCN at 2023-01-10 10:30 to 11:50
              OUTPUT
            ).to_stdout
          end
        end

        context 'when itinerary exists' do
          let(:based) { 'BCN' }
          let(:itinerary) { create(:itinerary, based_iata: based, raw_content: raw_itinerary_content) }
          let!(:segments) do
            [
              create(:segment, segment_type: 'Hotel', on: 'SVQ', from_date: '2023-01-05', to_date: '2023-01-10',
                               itinerary: itinerary),
              create(:segment, segment_type: 'Flight', from: 'BCN', from_date: '2023-01-05', from_time: '20:40',
                               to: 'SVQ', to_time: '22:10', itinerary: itinerary),
              create(:segment, segment_type: 'Flight', from: 'SQV', from_date: '2023-01-10', from_time: '10:30',
                               to: 'BCN', to_time: '11:50', itinerary: itinerary)
            ]
          end
          let(:service) { ItineraryService.new(based, raw_itinerary_content) }

          it 'prints the correct itinerary' do
            expect { service.humanify }.to output(
              <<~OUTPUT
                TRIP to SVQ
                Flight from BCN to SVQ at 2023-01-05 20:40 to 22:10
                Hotel at SVQ on 2023-01-05 to 2023-01-10
                Flight from SQV to BCN at 2023-01-10 10:30 to 11:50
              OUTPUT
            ).to_stdout
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
