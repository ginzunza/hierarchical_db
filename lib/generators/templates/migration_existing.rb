class HierarchicalDb<%= plural_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= plural_name %>, :lft, :integer
    add_column :<%= plural_name %>, :rgt, :integer
   end
end
