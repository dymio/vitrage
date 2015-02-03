require 'rails/generators/active_record'

module Vitrage
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      desc "Create the necessary migration and model for Vitrage"

      argument :name, type: :string, default: "VitragePiece" # TODO we don't needs name

      source_root File.expand_path("../templates", __FILE__)

      def copy_vitrage_piece_model_file
        copy_file "vitrage_piece.rb", "app/models/vitrage_piece.rb"
      end

      def create_vitrage_piece_migration
        migration_template 'migrations/create_vitrage_pieces.rb', 'db/migrate/create_vitrage_pieces.rb'
      end
    end
  end
end
