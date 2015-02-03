class CreateVitragePieces < ActiveRecord::Migration
  def self.up
    create_table :vitrage_pieces do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :item,  polymorphic: true, index: true
      t.integer    :ordn,  default: 9, null: false
      t.timestamps
    end

    add_index :vitrage_pieces, :ordn
  end

  def self.down
    drop_table :vitrage_pieces
  end
end
