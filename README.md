# ActionController::Parents

[![Gem
Version](https://badge.fury.io/rb/action_controller-parents.png)](http://badge.fury.io/rb/action_controller-parents)
[![Build
Status](https://travis-ci.org/mcls/action_controller-parents.png?branch=master)](https://travis-ci.org/mcls/action_controller-parents)
[![Code
Climate](https://codeclimate.com/github/mcls/action_controller-parents.png)](https://codeclimate.com/github/mcls/action_controller-parents)

Easily access parent resources.

## Installation

Add this line to your application's Gemfile:

    gem 'action_controller-parents'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_controller-parents

## Usage

Extend your `ApplicationController` with the 
`ActionController::Parents::Methods` module and use `parent_resources`:

```ruby
  class ApplicationController < ActionController::Base
    extend ActionController::Parents::Methods
  end

  class MembersController < ApplicationController
    parent_resources Group, Organization

    # GET /organizations/:organization_id/members
    # GET /groups/:group_id/members
    def index
      @members = parent_resource.members
    end
  end
```

Or use `ActionController::Parents` directly:

```ruby
  class MembersController < ActionController::Base
    include ActionController::Parents.new(Organization, Group)

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
