# StickyParams

A little gem that automaticly remembers the request parameters between requests without hassle.
For example for remembering the filtering and sorting of a list,  when switching to a detail screen and back.

```ruby
class MyController < ApplicationController
  def index
    @order = sticky_params[:order]
    @q  = sticky_params[:q]
  end
end
```

## Releease 2.0.0

Release 2.0.0 converts hashes to ActionController::Parameters.
This make using the of strong parameter permit constructs possible.

To get the 1.0 behaviour, you can add the following to your ApplicationController.

```ruby
  def sticky_params
    @sticky_params ||= ::StickyParams::SessionParams.new(self)
  end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sticky_params'
```

And then execute:

```bash
    $ bundle
```

## Usage

Just start using it, by simply replacing the normal params call with a sticky_params call:

```ruby
class MyController < ApplicationController
  def index
    @order = sticky_params[:order]
    @q  = sticky_params[:q]
  end
end
```

You can also store stuff in the sticky params hash

```ruby
sticky_params["keyname"] = "value"
```

### Remove sticky stuff

Sticky parameters can be removed one by one, by simply passing a empty string.

```ruby
sticky_params[:order] = ""  # removes the keyname order from the session
```

To remove all sticky stuff for the current controller/action you can simply call clear!

```ruby
sticky_params.clear!
```

To remove all sticky stuff, for every action/controller you can use clear_all!
But probably you don't want this ;)

```ruby
sticky_params.clear_all!
```

### Inner workings

Sticky params are stored in the session storage. They are stored in a
session variable named 'sticky_params'.

This session variable is a hash and it uses a prefix for storing the variables.
By default the prefix is "controller_action_"

When retrieving a parameter from sticky_params it first tries to retrieve it from
the normal params hash. When it's in the params hash, it stores the result in the
sticky_params hash.
If the parameter isn't in the normal params hash it does a lookup in the session hash.
Pretty simple.

## Common Pattern

A pattern I used often with sticky_params, is using a request parameter 'reset' .


For example for a basic rest controller, I have an index action which shows all users.
The list of users is sortable, searchable and paged. When selecting a user in this table
I goto the user screen. When going back I want my selection to persist.

But when I enter the users index screen from my application-menu, I want to reset all my
filters. I supply a parameter reset:

```ruby
link_to("Users", users_path(reset: 1))
```

Normal links, for example the list button in the user screen

```ruby
link_to("Users", users_path)
```

In the controller the index action is implemented like this

```ruby
class UsersController < ApplicationController
  def index
    sticky_params.clear! if params[:reset]

    @order = sticky_params[:order]
    @page = sticky_params[:page]
    # ... other fancy controller stuf ...
  end
end
```

For the lazy developer:
you could force the reset parameter to always work in your application.

```ruby
class ApplicationController < ActionController::Base
  before_action :sticky_params_reset

protected:
  def sticky_params_reset
    sticky_params.clear! if params[:reset]
  end
end
```

have fun ;)
