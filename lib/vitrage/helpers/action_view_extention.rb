module Vitrage
  # = Helpers
  module ActionViewExtension
    # A helper that renders the show view of vitrage
    #
    #   <%= show_vitrage_for @page %>
    #
    def show_vitrage_for(owner_object)
      render partial: 'vitrage/show', locals: { owner: owner_object }
    end

    # A helper that renders the show view of vitrage
    #
    #   <%= edit_vitrage_for @page %>
    #
    def edit_vitrage_for(owner_object)
      render partial: 'vitrage/edit', locals: { owner: owner_object }
    end
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::Base.send :include, Vitrage::ActionViewExtension
end
