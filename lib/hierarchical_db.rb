require "hierarchical_db/version"
require 'active_support/concern'

module HierarchicalDb extend ActiveSupport::Concern

  included do
    before_create :insert_node if self.is_sorted?
    after_destroy :destroy_node if self.is_sorted?
  end

  module ClassMethods
    def saludar
      puts "Hola"
    end
    
    def is_sorted?
      unless self.first.nil?
        !self.first.lft.nil?
      else
        false
      end
    end

    def sort_tree
      instance_node = self.new
      root_nodes = self.where(:"#{instance_node.parent_key}" => nil).to_a
      if root_nodes.length == 1
        root_nodes[0].sort_subtree(1)
      else
        right = 2
        root_nodes.each{|n| right = n.sort_subtree(right) }
      end
    end

    def display_tree
      instance_node = self.new
      self.where(:"#{instance_node.parent_key}" => nil).each{|n| n.display_subtree }
    end
  end

  def sort_subtree left
    right = left + 1
    self.children.each{|child| right = child.sort_subtree(right) }
    self.lft = left
    self.rgt = right
    self.save
    return right + 1
  end

  def descendants
    self.class.where(lft: (self.lft + 1..self.rgt - 1)).order(:lft)
  end

  def descendants_count
    (self.rgt - self.lft - 1)/2
  end

  def insert_node
    father = self.parent
    previous_right = ""
    #case it has descendants
    unless father.nil?
      last_brother = father.descendants.where(:rgt => father.descendants.maximum(:rgt))
      unless last_brother.empty?
        last_brother = last_brother[0]
        previous_right = last_brother.rgt
        childs = self.class.where("lft > ?", previous_right)
        childs.each do |t|
          t.lft = t.lft + 2
          t.save
        end
        childs = self.class.where("rgt > ?", previous_right)
        childs.each do |t|
          t.rgt = t.rgt + 2
          t.save
        end
      end
    #case it is root
    else
      last_brother = self.class.where(:rgt => self.class.maximum(:rgt))
      unless last_brother.empty?
        last_brother = last_brother[0]
        previous_right = last_brother.rgt
      end
    end
    self.lft = previous_right + 1
    self.rgt = previous_right + 2
  end

  def destroy_node
    childs = self.class.where("lft > ?", self.rgt)
    childs.each do |t|
      t.lft = t.lft - 2
      t.save
    end
    childs = self.class.where("rgt > ?", self.rgt)
    childs.each do |t|
      t.rgt = t.rgt - 2
      t.save
    end
  end

  def display_subtree
    right = []
    self.descendants.each do |d|
      if right.length > 0
        while right.last < d.rgt do
          right.pop
        end 
      end
      puts ("  "*right.length) +"#{d.id}-" +d.name
      right << d.rgt
    end
    return ''
  end

  def path(joined = nil, included = false)
    inc = included ? "=" : ""
    nodes = self.class.where("lft <#{inc} ?", self.lft).where("rgt >#{inc} ?", self.rgt).order(:lft)
    return nodes.map(&:name).join(joined) unless joined.nil?
    return nodes
  end

end