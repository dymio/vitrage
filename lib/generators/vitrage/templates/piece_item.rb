module VitrageItems
  class <%= class_name %> < <%= parent_class_name.classify %>
    has_one :vitrage_piece, as: :item

    def params_for_permit
      [<%= attributes.each.map{|at| ":#{at.name}"}.join(', ')%>]
    end

  end
end
