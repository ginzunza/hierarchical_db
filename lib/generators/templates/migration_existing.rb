class HierarchicalDb<%= plural_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= plural_name %>, :lft, :integer
    add_column :<%= plural_name %>, :rgt, :integer
    add_column :<%= plural_name %>, :lvl, :integer
   end
end
