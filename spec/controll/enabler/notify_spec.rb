require 'spec_helper'

class Notifier
  include Controll::Enabler::Notify
end  

describe Controll::Enabler::Notify do
  subject { Notifier.new }

  context 'initial state' do
    describe '.notifications' do
      its(:notifications) { should be_empty }      
    end

    describe '.main_event' do
      its(:main_event) { should be_a Hashie::Mash }
    end

    describe '.create_notification' do
      specify { subject.send(:create_notification, :updated).should be_a Hashie::Mash }
    end

    describe '.create_event' do
      specify { subject.send(:create_event, :updated).should be_a Hashie::Mash }
    end

    describe '.create_notice' do
      specify { subject.send(:create_notice,:updated).should be_a Hashie::Mash }
    end

    describe '.notify' do 
      describe '.with name only' do
        specify { subject.notify(:updated).main_event.type.should == :notice }
      end

      describe 'name and :error type' do
        specify { subject.notify(:updated, :error).main_event.type.should == :error }
      end

      describe 'name and unknown type' do
        specify do
          expect { subject.notify(:updated, :unknown) }.to raise_error
        end
      end
    end

  end
end