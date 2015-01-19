# activerecord_static_data

This gem checks that models marked with static data are properly seeded when they are loaded. This is useful if you have code that depends on certain records existing.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_static_data'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_static_data

## Usage

`activerecord_static_data` provides a `static_data` method that allows you to explicitly list which records a static table should have. It keys off of a single column as a unique identifier. An error will be raised whenever the model is loaded if the model's table does not have the explicit list of records. You can override the check by setting this environment variable:

```
SKIP_REQUIRED_DATA=true
```

### Example

For example let's say you have a `Role` model that defines different groupings of permissions for users.
You might have a column on `roles` called `key_name` which you use as a unique identifer for each role.
Let's say you have the following key names: `regular`, `admin`, `super_admin` and you have code that depends on those records existing:

```ruby
admin_users = Role.find_by_key_name('admin').users
```

You can use the `static_data` method to define which key names you expect to be present:

```ruby
class Role < ActiveRecord::Base
  static_data :key_name, %w(regular admin super_admin)

  ...
end
```

Whenever the `Role` class is loaded, `activerecord_static_data` will check to make sure that the `roles` table is seeded with the exact key names you specified.
A `RuntimeError` will be raised if there are key names listed that aren't in the database or records in the database with key names that aren't explicitly listed.
For example:

```ruby
rails> Role
RuntimeError: Missing required key_names for Role: ["regular", "super_admin"]
...
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_record_static_data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
