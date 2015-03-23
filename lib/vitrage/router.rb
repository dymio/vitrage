module Vitrage
  module Router

    def routes(rails_router, options = {})
      if options[:controller]
        cs = options[:controller].to_s
        rails_router.post   '/vitrage/pieces'             => "#{cs}#create", as: :vitrage_pieces
        rails_router.get    '/vitrage/pieces/new'         => "#{cs}#new",    as: :new_vitrage_piece
        rails_router.get    '/vitrage/pieces/restore_order' => "#{cs}#restore_order", as: :restore_order_vitrage_pieces
        rails_router.get    '/vitrage/pieces/:id/edit'    => "#{cs}#edit",   as: :edit_vitrage_piece
        rails_router.get    '/vitrage/pieces/:id'         => "#{cs}#show",   as: :vitrage_piece
        rails_router.match  '/vitrage/pieces/:id'         => "#{cs}#update", via: [:patch, :put]
        rails_router.delete '/vitrage/pieces/:id'         => "#{cs}#destroy"
        rails_router.post   '/vitrage/pieces/:id/reorder' => "#{cs}#reorder", as: :vitrage_piece_reoder
      else
        rails_router.namespace :vitrage do
          rails_router.resources :pieces, except: [:index]
        end
      end
    end

  end
end
