# Controll

Some nice and nifty utilities to help you manage complex controller logic. 

## Background

This gem contains logic extracted from my `oauth_assist` gem/engine which again was a response to this article [oauth pure tutorial](http://www.communityguides.eu/articles/16).

## Justification

As you can see, the following `#create` REST action is a nightmare of complexity and flow control leading to various different flash messages and redirect/render depending on various outcomes... there MUST be a better way!

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
def create    
  FlowHandler::CreateService.new(self).execute
end
```

A `FlowHandler` can use Executors to encapsulate execution logic, which again can execute Commands that encapsulate business logic related to the user Session or models (data).

The FlowHandler can manage Redirect, Render and Notifications in a standardized, much more Object Oriented fashion, which adheres to the Single Responsibility pattern.

Controll has built in notification management which work both for flash messages (or other types of notifications) and as return codes for use in flow-control logic.

Using the `controll` helpers, you can avoid the typical Rails anti-pattern of Thick controllers, without bloating your Models with unrelated model logic or pulling in various Helper modules which pollute the space of the Controller anyhow!

## Usage

In your controller include the `Controll::Helper` helper module.

```ruby
class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => accessible_actions
  protect_from_forgery :except => :create

  # see 'controll' gem
  include Controll::Helper
end
```

Better yet, to make it available for all controllers, include it in your ApplicationController or any base controller of your choice.

```ruby
class ApplicationController
  include Controll::Helper
end
```

In your Controller you should define a Notifier and Commander to be used.

```ruby
class ServicesController < ApplicationController
  include Controll::Helper

  ...

  protected

  notifier :services
  commander :services

  # or simply
  controll :notifier, :commander
end
```

The Commander is where you register a set of related commands, typically for a specific controller.

```ruby
module Commanders
  class Services < Commander

    # register commands with controller
    commands :cancel_commit, :create_account, :signout

    def sign_in_command
      @sign_in_command ||= SignInCommand.new auth_hash: auth_hash, user_id: user_id, service_id: service_id, service_hash: service_hash, initiator: self
    end

    command_method :sign_out do
      @sign_out_command ||= SignOutCommand.new user_id: user_id, service_id: service_id, service_hash: service_hash, initiator: self
    end

    # delegations
    controller_methods :auth_hash, :user_id, :service_id, :service_hash
  end
end
```

The `#commands` class macro can be used to create command methods that only take the initiator (in this case the controller) as argument.

For how to implement the commands, see the `imperator` gem, or see the `oauth_assist` engine for a full example. There are now also nice macros available for creating command methods! The `Commander class extends `Imperator::Command::MethodFactory` making `#command_method` available-

We will implement this Notifier later when we know which notifications and errors we want to use/issue.

## FlowHandlers

For Controller actions that require complex flow control, use a FlowHandler:

```ruby
module FlowHandlers
  class CreateService < Control
    fallback do
      event == :no_auth ? do_render(:text => omniauth.to_yaml) : fallback_action
    end      

    event do
      Executors::Authenticator.new(controller).execute
    end

    renderer do
      default_path :signup_services_path
      events       :signed_in_new_user, :signed_in
    end

    redirecter do
      redirections :notice do
        {        
          signup_services_path: :signed_in_new_user
          services_path:        [:signed_in_connect, :signed_in_new_connect]
          root_url:             [:signed_in_user, :other]
        }
      end

      redirections :error, signin_path: [:error, :invalid, :auth_error]
    end  
  end
end
```

In the `Redirect` class we are setting up a mapping for various path, specifying which notifications/event should cause a redirect to that path.

If you are rendering or redirecting to paths that take arguments, you can either extend the `#action` class method of your Redirect or Render class implementation or you can define a `#use_alternatives` method in your `FlowHandler` that contains this particular flow logic. You can also use the `#use_fallback` method for this purpose.

## The Authenticator Executor

The `Authenticator` inherits from `Executor::Notificator` which uses `#method_missing` in order to delegate any missing method back to the initiator of the Executor, in this case the FlowHandler. The `#result` call at the end of `#execute` ensures that the last notification event is returned, to be used for deciding what to render or where to redirect (see FlowHandler).

```ruby
module Executors
  class Authenticator < Notificator
    def execute
      # creates an error notification named :error
      error and return unless valid_params?

      # creates an error notification named :auth_invalid
      error(:auth_invalid) and return unless auth_valid?

      command! :sign_in
      result      
    end

    protected

    def valid_params?
      omniauth and service and auth_hash
    end
  end
end
```

To encapsulate more complex busines logic affecting the user Session or Model data, we execute an the Imperator Command (see `imperator` gem) called :sign_in that we registered in the Commander of the Controller.

## Notifier

Now we are finally ready to define the message handler for each notification event we have defined (this should ideally be done as you define each event!).

The example below demonstrates several different ways you can define messages for events: 

* using the `#messages` method to return a hash of mappings. 
* define a method for the event name that returns a String (w argument replacement)
* i18n locale mapping [msghandler name].[notification type].[event name].

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

## Contributing to controll
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

