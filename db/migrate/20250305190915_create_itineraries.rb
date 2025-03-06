class CreateItineraries < ActiveRecord::Migration[8.0]
  def change
    create_table :itineraries do |t|
      t.string :based_iata
      t.string :raw_content

      t.timestamps
    end
  end
end
