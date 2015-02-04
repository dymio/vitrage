class VitrageOwnersPiecesSlot < ActiveRecord::Base
  # stored fields: :owner_type, :owner_id, :piece_type, :piece_id, :ordn

  belongs_to :owner, polymorphic: true
  belongs_to :piece, polymorphic: true, dependent: :destroy

  default_scope -> { order(ordn: :asc, id: :asc) }

  PIECE_CLASSES_STRINGS = [  ] # add pieces class names strings here (demodulized)
end
