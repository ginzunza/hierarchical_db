class HierarchicalDb<%= plural_name.camelize %> < ActiveRecord::Migration
  def self.up
    change_table(:<%= plural_name %>) do |t|
      t.integer :lft
      t.integer :rgt
    end
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end