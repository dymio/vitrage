module Vitrage
  module ActsAsVitrageOwner
    extend ActiveSupport::Concern
 
    included do
      has_many :vitrage_pieces, as: :owner, dependent: :destroy
    end
 
    module ClassMethods
      def acts_as_vitrage_owner(options = {})
        include Vitrage::ActsAsVitrageOwner
      end
    end
  end
end

ActiveRecord::Base.send :include, Vitrage::ActsAsVitrageOwner
