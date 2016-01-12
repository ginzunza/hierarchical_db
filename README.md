# HierarchicalDb

This gem has the implementation of **[Hierarchical databases](http://www.sitepoint.com/hierarchical-data-database/)**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hierarchical_db'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hierarchical_db

Next you have to use the hierarchical_db generator into your model. For example, if you have a model called *Territory* (to manage countries, cities and all the other hierarchies) with the following relationship:
```ruby
class Territory < ActiveRecord::Base
  belongs_to :parent_territory, class_name: 'Territory'
end
```
You have to execute the generator with the code below:
```
rails g hierarchical_db territories
```
Now your model has the attributes *lft* and *rgt* that are essential to the gem work properly.

Next into the model you have to include Hierarchies adding the code below:
```ruby
class Territory < ActiveRecord::Base
  include HierarchicalDb #we added this
  belongs_to :parent_territory, class_name: 'Territory'
end
```
Finally we add two alias methods that are useful and necessary to deal with hierarchies:
```ruby
class Territory < ActiveRecord::Base
  include HierarchicalDb 
  belongs_to :parent_territory, class_name: 'Territory'
  # alias methods
  alias_method :children, :territories #we added this
  alias_method :parent, :parent_territory #we added this
end
```
## Usage

Continuing the example, if you have data inside your Territory model, then you have to execute :
```ruby
  Territory.sort_tree
```
This is a Class method and is imperative to use this after load seeds or when you first enter information inside your model. If you don't have any data inside your model this method doesn't have any sense. On the other hand, if you have data inside your model and you has never executed *sort_tree* then this gem won't work.<br>
Sort_tree initializes your tree and fills *lft* and *rgt* attributes with corresponding information.
After execute this command you will able to use all useful methods below
###Useful Methods

#####display_tree
This is a Class method and returns graphically and tabulated the entire tree. Example:
```
Territory.display_tree
```
#####descendants
Returns an array with all childrens order by lft attribute, example:
```
object.descendants_count
```
#####descendants_count
If you want to know how many descendants has your model, then you can execute:
```
 object.descendants_count
 ```
 It returns a number of descendants.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hierarchical_db. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

