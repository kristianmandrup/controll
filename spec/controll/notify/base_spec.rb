require 'spec_helper'

class FlashController
  attr_reader :flash

  def initialize
    @flash = {}
  end
end

class Translator < Controll::Notify::Base
  type :notice

  def messages
    {
      must_sign_in: 'You need to sign in before accessing this page!',
      
      auth_service_error: %q{There was an error at the remote authentication service.
You have not been signed in.},
      
      cant_delete_current_account: 'You are currently signed in with this account!',
      user_save_error: 'This is embarrassing! There was an error while creating your account from which we were not able to recover.',
    }
  end

  def auth_error!
    'Error while authenticating via ' + service_name + '. The service did not return valid data.'
  end

  def auth_invalid!
    'Error while authenticating via {{full_route}}. The service returned invalid data for the user id.'
  end

  protected

  def service_name
    'facebook'
  end 
end

describe Controll::Notify::Base do
  subject { Translator.new controller }

  let(:controller) { FlashController.new }

  let(:sign_in_msg) { 'You need to sign in before accessing this page!' }

  describe 'notify - method' do
    specify do
      subject.notify('must_sign_in').should == sign_in_msg
    end
  end

  context 'I18n message' do
    # services:
    #   notice:
    #     signed_in:  'Your account has been created and you have been signed in!'
    #     signed_out: 'You have been signed out!'
    let(:signed_in_msg)   { 'Your account has been created and you have been signed in!' }
    let(:signed_out_msg)  { 'You have been signed out!' }

    before do
     ::I18n.backend.store_translations :en,
       :translator => {
         :signed_in => signed_in_msg,
         :signed_out => signed_out_msg
        }
    end

    after do
     ::I18n.backend.reload!
    end

    describe "t 'signed_in'" do
      specify do
        subject.notify('signed_in').should == signed_in_msg
      end      
    end
  end

  context 'Variable substitution' do
    # context 'method calls' do
    #   let(:auth_error_msg) { 'Error while authenticating via facebook. The service did not return valid data.' }

    #   specify do
    #     subject.notify('auth_error!').should == auth_error_msg
    #   end      
    # end

    context 'Liquid templates with args' do      
      let(:auth_error_msg) { 'Error while authenticating via www.facebook.com/login. The service returned invalid data for the user id.' }

      specify do
        subject.notify(:auth_invalid!, full_route: 'www.facebook.com/login').should == auth_error_msg
      end      
    end

    context 'I18n messages with args' do
      let(:name)  { 'kris' }

      before do
       ::I18n.backend.store_translations :en,
         :translator => {
           :signed_out => "Hey %{name}, you have been signed out!"
          }
      end

      after do
       ::I18n.backend.reload!
      end

      specify do
        subject.notify(:signed_out, name: name).should == "Hey #{name}, you have been signed out!"
      end
    end
  end
end