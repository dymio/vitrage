require 'rails/generators/active_record/model/model_generator'

# I think it isn't optimal solution for items models generation. Rethink.

module Vitrage
  module Generators
    class PieceGenerator < ActiveRecord::Generators::ModelGenerator
      desc "Create vitrage piece model, migration and necessary views"

      source_root File.expand_path("../templates", __FILE__)

      def class_name
        clsn = super
        clsn[0..3] == "Vtrg" ? clsn : "Vtrg#{clsn}"
      end

      def file_name
        flen = super
        flen[0..4] == "vtrg_" ? flen : "vtrg_#{flen}"
      end

      def table_name
        tbns = super
        tbns[0..4] == "vtrg_" ? tbns : "vtrg_#{tbns}"
      end

      # override ActiveRecord::Generators::ModelGenerator method
      def create_migration_file
        return unless options[:migration] && options[:parent].nil?
        attributes.each { |a| a.attr_options.delete(:index) if a.reference? && !a.has_index? } if options[:indexes] == false
        migration_template "migrations/create_piece_item.rb", "db/migrate/create_#{table_name}.rb"
      end

      # override ActiveRecord::Generators::ModelGenerator method
      def create_model_file
        template 'piece_item.rb', File.join('app/models/vitrage/', class_path, "#{file_name}.rb")
      end

      def create_necessary_views
        copy_file 'views/item_show_generator.html.erb', File.join('app/views/vitrage/', "_#{file_name}.html.erb")
        copy_file 'views/item_form_generator.html.erb', File.join('app/views/vitrage/', "_#{file_name}_form.html.erb")
      end
    end
  end
end
