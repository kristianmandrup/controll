module Notifiers
  class Services < Controll::Notify::Typed
    class Base < Controll::Notify::Base
      def provider_name
        provider.capitalize
      end

      def service_name
        service_route.capitalize
      end

      def full_route
        service_route + '/' + provider_name
      end
    end

    class ErrorHandler < Base
      type :error

      def messages
        {
          must_sign_in: 'You need to sign in before accessing this page!',
          
          auth_service_error: %q{There was an error at the remote authentication service.
You have not been signed in.},
          
          cant_delete_current_account: 'You are currently signed in with this account!',
          user_save_error: 'This is embarrassing! There was an error while creating your account from which we were not able to recover.',
        }
      end

      def bad
        'bad stuff!'
      end

      def auth_error!
        'Error while authenticating via ' + service_name + '. The service did not return valid data.'
      end

      def auth_invalid!
        'Error while authenticating via {{full_route}}. The service returned invalid data for the user id.'
      end
    end

    class NoticeHandler < Base
      # for :signed_in and :signed_out - defined in locale file under:

      # services:
      #   notice:
      #     signed_in:  'Your account has been created and you have been signed in!'
      #     signed_out: 'You have been signed out!'

      def already_connected
        'Your account at {{provider_name}} is already connected with this site.'
      end

      def account_added
        'Your {{provider_name}} account has been added for signing in at this site.'
      end

      def sign_in_success
        'Signed in successfully via {{provider_name}}.'
      end

      def hello
        'hello you'
      end
    end
  end
end