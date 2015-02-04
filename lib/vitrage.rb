require "vitrage/engine"
require "vitrage/acts_as_vitrage_owner"
require "vitrage/helpers/action_view_extention"

module Vitrage
  class << self
    def routes(rails_router, options = {})
      if options[:controller]
        cs = options[:controller].to_s
        rails_router.post   '/vitrage/pieces'          => "#{cs}#create", as: :vitrage_pieces
        rails_router.get    '/vitrage/pieces/new'      => "#{cs}#new",    as: :new_vitrage_piece
        rails_router.get    '/vitrage/pieces/:id/edit' => "#{cs}#edit",   as: :edit_vitrage_piece
        rails_router.get    '/vitrage/pieces/:id'       => "#{cs}#show",  as: :vitrage_piece
        rails_router.match  '/vitrage/pieces/:id'       => "#{cs}#update", via: [:patch, :put]
        rails_router.delete '/vitrage/pieces/:id'       => "#{cs}#destroy"
      else
        rails_router.namespace :vitrage do
          rails_router.resources :pieces, except: [:index]
        end
      end
    end
  end
end
