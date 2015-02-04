class VitragePiece < ActiveRecord::Base
  # stored fields: :owner_type, :owner_id, :item_type, :item_id, :ordn

  belongs_to :owner, polymorphic: true
  belongs_to :item, polymorphic: true, dependent: :destroy

  default_scope -> { order(ordn: :asc, id: :asc) }

  ITEM_KINDS = [  ] # add items class names # TODO move to yml config
end
