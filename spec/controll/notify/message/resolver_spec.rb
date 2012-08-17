require 'spec_helper'

module Services
  class NoticeHandler
  end
end

describe Controll::Notify::Message::Resolver do
  subject { Controll::Notify::Message::Resolver.new caller, message }

  let(:caller)     { Services::NoticeHandler.new }
  let(:message)    { Controll::Notify::Message.new text, options  }
  let(:text)       { 'Error while authenticating via {{full_route}}. The service returned invalid data for the user id.' }
  let(:options) do
    {:full_route => 'the_path', :name => 'kris'}
  end

  describe '.initialize message' do
    its(:message) { should == message } 
  end

  describe '.resolve' do
    context 'simple text' do
      let(:text)       { 'simple text' }

      its(:resolve) { should == text }
    end

    context 'with arg replacement' do
      its(:resolve) { should == 'Error while authenticating via the_path. The service returned invalid data for the user id.' }
    end

    context 'translation' do
      let(:text) { :signed_out }
      let(:name) { 'kris' }

      before do
       ::I18n.backend.store_translations :en,
         :services => {
           :notice => {
             :signed_out => "Hey %{name}, you have been signed out!"
            }
          }
      end

      after do
       ::I18n.backend.reload!
      end

      its(:resolve) { should == "Hey #{name}, you have been signed out!" }
    end
  end
end