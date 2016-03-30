require 'active_support'
require 'active_support/rails'
require 'hierarchical_db/version'

module HierarchicalDb
  extend ActiveSupport::Autoload

  autoload :Base
end