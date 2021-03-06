require 'spec_helper'

class NoEventsRender < Controll::Flow::ActionMapper::Simple
  def self.events
    []
  end
end

class HiRender < Controll::Flow::ActionMapper::Simple
  def self.events
    [:hi]
  end
end

class HelloRender < Controll::Flow::ActionMapper::Simple
  events :hello, :damn
  default_path '/default'
end

class NiceController
end

def notification name
  Hashie::Mash.new(name: name.to_sym, type: :notice)
end

describe Controll::Flow::ActionMapper::Simple do

  Simple  = Controll::Flow::ActionMapper::Simple
  Complex = Controll::Flow::ActionMapper::Complex

  let(:controller) { NiceController }
  let(:hello) { notification :hello }  

  context 'use directly without sublclassing' do
    subject { clazz.new '/' }

    let(:clazz) { Simple }

    describe '.action event' do
      specify do
        expect { clazz.action(controller, hello) }.to raise_error(Controll::Flow::NoEventsDefinedError)
      end
    end
  end

  context 'NoEventsRender subclass' do
    subject { clazz.new '/' }

    let(:clazz) { NoEventsRender }

    context 'empty events' do
      describe '.action event' do
        specify do
          expect { clazz.action(controller, hello) }.to raise_error(Controll::Flow::NoEventsDefinedError)
        end
      end
    end
  end

  context 'HiRender subclass' do
    subject { clazz.new '/' }

    let(:clazz) { HiRender }
    let(:event) { notification :hello }

    context 'has events' do
      describe '.action event' do

        describe 'does not respond to hello' do
          specify do
            expect { clazz.action(controller, event) }.to_not raise_error(Controll::Flow::NoEventsDefinedError)
          end

          specify do
            expect { clazz.action(controller, event) }.to raise_error Controll::Flow::NoDefaultPathDefinedError
          end
        end

        describe 'responds to hi' do
          # default_path not implemented!
          specify do
            expect { clazz.action(controller, :hi) }.to raise_error Controll::Flow::NoDefaultPathDefinedError
          end
        end
      end
    end
  end

  context 'HelloRender subclass' do
    subject { clazz.new default_path }

    let(:clazz) { HelloRender }
    let(:event) { notification :hello }
    let(:default_path) { '/default' } 

    context 'has events and default_path' do
      describe '.action event' do
        specify do
          clazz.action(controller, event).should be_a Controll::Flow::Action::PathAction
        end        

        specify do
          clazz.action(controller, event).path.should == default_path
        end        

        specify do
          clazz.action(controller, event, 'other_path').path.should == 'other_path'
        end        
      end
    end
  end  
end