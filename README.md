# ActionController::Parents

Easily access parent resources.

## Installation

Add this line to your application's Gemfile:

    gem 'action_controller-parents'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_controller-parents

## Usage

Example: 

```ruby
  class MembersController < ActionController::Base
    include Parents.new(Organization, Group)

    # GET /organizations/:organization_id/members
    # GET /groups/:group_id/members
    def index
      @members = parent_resource.members
    end
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
