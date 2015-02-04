module VitragePieces
  class <%= class_name %> < <%= parent_class_name.classify %>
    has_one :slot, class_name: "VitrageOwnersPiecesSlot", as: :piece

    def params_for_permit
      [<%= attributes.each.map{|at| ":#{at.name}"}.join(', ')%>]
    end

  end
end
