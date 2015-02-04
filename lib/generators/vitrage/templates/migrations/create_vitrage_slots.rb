class CreateVitrageOwnersPiecesSlots < ActiveRecord::Migration
  def self.up
    create_table :vitrage_owners_pieces_slots do |t|
      t.references :owner, polymorphic: true, null: false, index: true
      t.references :piece, polymorphic: true,              index: true
      t.integer    :ordn,  default: 9,        null: false
      t.timestamps
    end

    add_index :vitrage_owners_pieces_slots, :ordn
  end

  def self.down
    drop_table :vitrage_owners_pieces_slots
  end
end
