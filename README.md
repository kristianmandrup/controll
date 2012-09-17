# Controll

Some nice and nifty utilities to help you manage complex controller logic.

## Requirements

This gem is designed for Rails 3+ and currently only supports (has been tested with)  Ruby 1.9+. The gem is under development but stable releases will be pushed to rubygems. Note that older versions may not support the same API described in the README. Go back in history and/or browse the code for that specific version.

Enjoy :)

## Background

This gem contains logic extracted from my [oauth_assist](https://github.com/kristianmandrup/oauth_assist) gem (and engine) which was a response to this article [oauth pure tutorial](http://www.communityguides.eu/articles/16).

Note that the *oauth_assist* gem is not yet fully functional and done, as it "awaits" a stable release of this gem. Please feel free to help out in this effort!

## Justification

As you can see, the following `#create` REST action is a nightmare of complexity and flow control leading to various different flash messages and redirect/render depending on various outcomes... 

Then I naturally thought: *There MUST be a better way!*

```ruby
def create
  # get the service parameter from the Rails router
  params[:service] ? service_route = params[:service] : service_route = 'No service recognized (invalid callback)'

  # get the full hash from omniauth
  omniauth = request.env['omniauth.auth']
  
  # continue only if hash and parameter exist
  if omniauth and params[:service]

    # map the returned hashes to our variables first - the hashes differs for every service
    
    # create a new hash
    @authhash = Hash.new
    
    extract_auth_data!
           
    if unknown_auth?       
      # debug to output the hash that has been returned when adding new services
      render :text => omniauth.to_yaml
      return
    end 
    
    if @authhash[:uid] != '' and @authhash[:provider] != ''
      
      auth = Service.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

      # if the user is currently signed in, he/she might want to add another account to signin
      if user_signed_in?
        if auth
          flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
          redirect_to services_path
        else
          current_user.services.create!(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:name], :uemail => @authhash[:email])
          flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
          redirect_to services_path
        end
      else
        if auth
          # signin existing user
          # in the session his user id and the service id used for signing in is stored
          session[:user_id] = auth.user.id
          session[:service_id] = auth.id
        
          flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
          redirect_to root_url
        else
          # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
          session[:authhash] = @authhash
          render signup_services_path
        end
      end
    else
      flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
      redirect_to signin_path
    end
  else
    flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
    redirect_to signin_path
  end
end
```

Using the tools contained in `controll` the above logic can be encapsulated like this:

```ruby
class ServicesController < ApplicationController
  include Controll::Enabler

  def create
    execute # action.perform
  end
end
```

A `Flow` can use Executors to encapsulate execution logic, which again can execute Commands that encapsulate business logic related to the user Session or models (data).

The Flow takes the last event on the event stack and consults the ActionPaths registered, usually a Redirecter and Renderer. An ActionPath is a type of Action which can return a path. The Flow initiates an Executor which iterates the ActionPaths to find the first one which can match the event.

The first one with a match is returned as the Action, which the controller can then perform in order to either render or redirect.

If none of the ActionPaths can match the event, a Fallback Action is returned. The controller should then be configured to handle a Fallback Action appropriately.

Controll has built in Notification Management which work both for flash messages (or other types of notifications) and as return codes for use in flow-control logic.

All events in the event stack are processed and can fx be put on the flash hash according to event type, fx `flash[:error]` for an `:error` event etc.

The Notification system works by mapping events to messages in a central location, similar to mapping events to paths.

Using these Controll artifacts/systems, you can avoid the typical Rails anti-pattern of Thick controllers, without bloating your Models with unrelated model logic or pulling in various Helper modules which pollute the space of the Controller!

## Usage

The recommended approach to handle complex Controller logic using Controll:

* Enable Controll on Controller
* Configure Controller with Flow, Commander and Notifier

* Create Commands for Commander
* Define events corresponding to commands
* Configure Commander with Command methods

* Create Flow
* Configure Flow with Render and Redirect event mappings

* Create Notifier
* Configure Notifier with Event handlers and event -> message mappings

## Controll enabling a Controller

In your controller include the `Controll::Enabler` module.

```ruby
class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => accessible_actions
  protect_from_forgery :except => :create

  # see 'controll' gem
  include Controll::Enabler
end
```

Better yet, to make it available for all controllers, include it in your ApplicationController or any base controller of your choice.

```ruby
class ApplicationController
  include Controll::Enabler
end
```

You can also include the `Controll::Macros` module in a base Controller class of your choosing, fx:

```ruby
class ApplicationController
  include Controll::Macros
end
```

Then you can use the `#enable_controll` macro in any subclass Controller class:

```ruby
class ServicesController < ApplicationController
  enable_controll
end
```

## Controll configuration

In your Controller you should define a Notifier and Commander to be used.

```ruby
class ServicesController < ApplicationController
  enable_controll

  ...

  protected

  notifier :services
  commander :services

  # or simply (using naming convention)
  controll :notifier, :commander

  def create
    create_action.perform
  end

  protected

  def create_action
    @create_action ||= Flows::CreateService.new(self)
  end

  fallback do |event|
    event == :no_auth ? render(:text => omniauth.to_yaml) : fallback_action
  end        

  def fallback_action
    redirect_to root_url
  end
end
```

### Focused Controller config

In case you use Focused Controller, this can be strutctured even better like this:

```ruby
class ServicesController

  # could be extracted into "global" namespace for reuse across controllers...
  module ControllAction
    extend ActiveSupport::Concern

    included do
      controll :notifier, :commander, :flow
    end

    def fallback_action
      redirect_to root_url
    end
  end

  class Create < FocusedAction
    include ControllAction

    run do
      execute
    end

    protected

    fallback do |event|
      event == :no_auth ? render(:text => omniauth.to_yaml) : fallback_action
    end        
  end
end
```

*Wow! Now we're talking!!!!*

## Creating a Commander

The Commander is your command center for a group of related commands. Typically you will want to define a Commander for a specific controller if the controller has more than 3 commands. If you put your Commander under the `Commanders` namespace (module) you get direct access to the Commander constant to be used as subclass.

The Commander should contain a group of command methods that are conceptually in the same "category", fx all the command for a particular controller.

```ruby
module Commanders
  class Services < Commander
    # create basic command methods
    command_methods :cancel_commit, :create_account, :signout

    # create custom command method with custom argument hash
    def sign_in_command
      @sign_in_command ||= SignInCommand.new auth_hash: auth_hash, user_id: user_id, service_id: service_id, service_hash: service_hash, initiator: self
    end

    command_method :sign_out do
      @sign_out_command ||= SignOutCommand.new user_id: user_id, service_id: service_id, service_hash: service_hash, initiator: self
    end

    # delegations (alias for initiator_methods )
    controller_methods :auth_hash, :user_id, :service_id, :service_hash
  end
end
```

The `Commander class extends `Imperator::Command::MethodFactory` making `#command_method` and `#command_methods` available. These class macros can be used to create command methods that only take the initiator (in this case the controller) as argument.

For how to implement the Commands themselves, see the [imperator-ext](https://github.com/kristianmandrup/imperator-ext) gem. 

## Flows

For Controller actions that require complex flow control, use a Flow:

```ruby
module Flows
  class CreateService < Flow

    # event method that returns the event to be processed by the flow handler
    event do
      Executors::Authenticator.new(controller).execute
    end

    # configuration of the Renderer ActionHandler
    # will return a Renderer Action if it matches the event
    renderer :simple do
      events :signed_in_new_user, :signed_in do
        signup_services_path
      end
    end

    # configuration of the Redirecter ActionHandler
    # will return a Redirecter Action if it matches the event
    redirecter :complex do
      # redirection mappings for :notice events
      event_map :notice do
        {        
          signup_services_path: :signed_in_new_user
          services_path:        [:signed_in_connect, :signed_in_new_connect]
          root_url:             [:signed_in_user, :other]
        }
      end

      # redirection mappings for :error events
      event_map :error, signin_path: [:error, :invalid, :auth_error]
    end  
  end
end
```

The `#renderer` and `#redirector` macros will each create a Class of the same name that inherit from Controll::Flow::ActionMapper::Simple or Controll::Flow::ActionMapper::Complex. 
You can also define these classes directly yourself instead of using the macros.
The *simple* action mapper maps a list of events to a single path and otherwise falls back.
The complex action mapper maps the event to an event hash for each registered event type.

In the `Redirecter` class we are setting up a mapping for various paths, for each path specifying which events should cause a redirect to that path.

If you are rendering or redirecting to paths that take arguments, you can either extend the `#action` class method of your Redirect or Render class implementation or you can define a `#use_alternatives` method in your `Flow` that contains this particular flow logic.

Note: For mapping paths that take arguments, there should be an option to take a block (closure) to be late-evaluated on the controller context ;)

## The Executor

The `Authenticator` class shown below inherits from `Executor::Notificator` which uses `#method_missing` in order to delegate any missing method back to the controller of the Executor. The Flow passed in the controller. This means that calls can be executed directly on the controller, such as making notifications etc.

The `#result` call at the end of `#execute` ensures that the last notification event is returned, to be used for deciding what to render or where to redirect (see Flow).

```ruby
module Executors
  class Authenticator < Controlled

    # ensures pattern:
    # - perform validations and only execute command if no error
    def execute
      super      
      result      
    end

    protected

    controller_methods :omniauth, :service, :auth_hash, :auth_valid?

    def do_command
      command! :sign_in
    end

    def validations
      # creates an error notification named :error
      error and return unless valid_params?

      # creates an error notification named :auth_invalid
      error(:auth_invalid) and return unless auth_valid?
    end    

    def valid_params?
      omniauth and service and auth_hash
    end
  end
end
```

Alternatively you can use the execute block macro to generate the `#execute` instance method and ensure that it ends by returning result.

```ruby
execute do
  # error/validation checks? ...
  command! :sign_in
end
```

To encapsulate more complex busines logic affecting the user Session or Model data, we execute an Imperator Command (see `imperator` gem) called :sign_in that we registered in the Commander of the Controller.

## Notifier

Now we are finally ready to define the notifier to handle the different types of notification events.

The example below demonstrates several different ways you can define messages for events: 

* using the `#messages` method to return a hash of mappings. 
* define a method for the event name that returns a String (handles argument replacement)
* i18n locale mapping `[handler class path].[notification type].[event name]`.

```ruby
module Notifiers
  class Services < Typed
    handler :error do
      messages do
        {
          must_sign_in: 'You need to sign in before accessing this page!',
          
          auth_service_error: %q{There was an error at the remote authentication service.
You have not been signed in.},
          
          cant_delete_current_account: 'You are currently signed in with this account!',
          user_save_error: 'This is embarrassing! There was an error while creating your account from which we were not able to recover.',
        }
      end

      msg :auth_error! do
        "Error while authenticating via #{service_name}. The service did not return valid data."
      end

      msg :auth_invalid! do
        'Error while authenticating via {{full_route}}. The service returned invalid data for the user id.'
      end
    end


    handler :notice do
      # for :signed_in and :signed_out - defined in locale file under:
      # notifiers:
      #   services:
      #     notice:
      #       signed_in:  'Your account has been created and you have been signed in!'
      #       signed_out: 'You have been signed out!'

      msg :already_connected do
        'Your account at {{provider_name}} is already connected with this site.'
      end

      msg :account_added do
        'Your {{provider_name}} account has been added for signing in at this site.'
      end

      msg :sign_in_success do
        'Signed in successfully via {{provider_name}}.'
      end
    end
  end
end
```

## Rails Generators

### Setup generator

`$ rails g controll:setup`

Generate only specific controll folders

`$ rails g controll:setup commanders notifiers`

### Controll artifact generators

* assistant
* executor
* flow
* notifier

Example usage:

`$ rails g controll:flow create_service`

Use `-h` for help on any specific controller for more usage options and info.

## Notice

Due to a lot of recent API changes in order to simplify and improve usage, the README docs for the API might potentially contain a few inconsistencies with the code. Please notify me if you spot one. Thanks. See the specs and/or code in order to see the real API in this case.

## Contributing to controll
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

