require 'spec_helper'

class Notifier
  include Controll::Enabler::Notify
end  

describe Controll::Enabler::Notify do
  subject { Notifier.new }

  context 'initial state' do
    describe '.main_event' do
      its(:main_event) { should be_a Controll::Event }
    end

    Controll::Event.valid_types.each do |type|
      describe ".create_#{type}" do
        specify { subject.send(:"create_#{type}",:updated).should be_a Controll::Event }
      end
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