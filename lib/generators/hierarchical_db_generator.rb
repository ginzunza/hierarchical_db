require 'rails/generators/named_base'
require 'rails/generators/active_record'

module HierarchicalDb
  module Generators
    class HierarchicalDbGenerator < ActiveRecord::Generators::Base

    include Rails::Generators::ResourceHelpers

    namespace "hierarchical_db"

    desc "Creates HierarchicalDb Migrations"

    source_root File.expand_path("../templates", __FILE__)

    def copy_migration
      migration_template "migration_existing.rb", "db/migrate/hierarchical_db_to_#{plural_name.downcase}"
    end

      def migration_data
  # <<RUBY
    ## Add active column to table
    t.integer :lft
    t.integer :rgt
  # RUBY
      end
    end
  end
end