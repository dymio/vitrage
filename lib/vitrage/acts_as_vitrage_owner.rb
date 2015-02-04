module Vitrage
  module ActsAsVitrageOwner
    extend ActiveSupport::Concern
 
    module ClassMethods
      def acts_as_vitrage_owner
        has_many :vitrage_slots, class_name: "VitrageOwnersPiecesSlot",
                                 as: :owner,
                                 dependent: :destroy
      end
    end
  end
end

ActiveRecord::Base.send :include, Vitrage::ActsAsVitrageOwner
