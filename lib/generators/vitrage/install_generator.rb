require 'rails/generators/active_record'

module Vitrage
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Create migration, model and routes for Vitrage"

      argument :name, type: :string, default: "VitragePiece" # TODO we don't needs name

      source_root File.expand_path("../templates", __FILE__)

      def copy_vitrage_piece_model_file
        copy_file "vitrage_slot.rb", "app/models/vitrage_owners_pieces_slot.rb"
      end

      def create_vitrage_piece_migration
        migration_template "migrations/create_vitrage_slots.rb",
                           "db/migrate/create_vitrage_owners_pieces_slots.rb"
      end

      def add_routes
        route "Vitrage.routes(self)"
      end
    end
  end
end
