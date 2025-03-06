class CreateSegments < ActiveRecord::Migration[8.0]
  def change
    create_table :segments do |t|
      t.belongs_to :itinerary, foreign_key: "itinerary_id"
      t.string :segment_type, null: false
      t.string :from
      t.string :to
      t.string :on
      t.date :from_date
      t.time :from_time
      t.date :to_date
      t.time :to_time

      t.timestamps
    end
  end
end
