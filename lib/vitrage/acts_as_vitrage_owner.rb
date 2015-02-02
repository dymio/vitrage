module Vitrage
  module ActsAsVitrageOwner
    extend ActiveSupport::Concern
 
    # included do
    # end
 
    module ClassMethods
      def acts_as_vitrage_owner(options = {})
        has_many :vitrage_pieces, as: :owner, dependent: :destroy
      end
    end
  end
end

ActiveRecord::Base.send :include, Vitrage::ActsAsVitrageOwner
