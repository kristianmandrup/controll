require 'spec_helper'

module Services
  class NoticeHandler
  end
end

describe Controll::Notify::Message::Translator do
  subject { Controll::Notify::Message::Translator.new caller, message }

  let(:caller)     { Services::NoticeHandler.new }
  let(:message)    { Controll::Notify::Message.new key, options  }
  let(:key)        { :signed_out }
  let(:options) do
    {:name => 'kris'}
  end

  describe '.initialize caller, message' do
    its(:caller)  { should == caller }
    its(:key)     { should == key }
    its(:key)     { should == message.text }
    its(:options) { should == message.options }
    its(:options) { should == options }

    context 'I18n messages with args' do
      let(:name)  { 'kris' }

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

      specify do
        subject.translate.should == "Hey #{name}, you have been signed out!"
      end
    end
  end
end