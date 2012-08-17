require 'spec_helper'

class NoEventsRender < Controll::FlowHandler::Render
  def self.events
    []
  end
end

class HiRender < Controll::FlowHandler::Render
  def self.events
    [:hi]
  end
end

class HelloRender < Controll::FlowHandler::Render
  events :hello, :damn
  set_default_path '/default'
end

def notification name
  Hashie::Mash.new(name: name.to_sym, type: :notification)
end

describe Controll::FlowHandler::Render do

  context 'use directly without sublclassing' do
    subject { clazz.new '/' }

    let(:clazz) { Controll::FlowHandler::Render }

    let(:hello) { notification :hello }

    describe '.action event' do
      specify do
        expect { clazz.action(:hello) }.to raise_error(Controll::FlowHandler::NoEventsDefinedError)
      end
    end
  end

  context 'NoEventsRender subclass' do
    subject { clazz.new '/' }

    let(:clazz) { NoEventsRender }

    context 'empty events' do
      describe '.action event' do
        specify do
          expect { clazz.action(:hello) }.to raise_error(Controll::FlowHandler::NoEventsDefinedError)
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
            expect { clazz.action(:hello) }.to_not raise_error(Controll::FlowHandler::Render::NoEventsDefinedError)
          end

          specify do
            clazz.action(event).should == nil
          end

          specify do
            clazz.action(:hello).should == nil
          end
        end

        describe 'responds to hi' do
          # default_path not implemented!
          specify do
            expect { clazz.action(:hi) }.to raise_error NotImplementedError
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
          clazz.action(event).should be_a HelloRender
        end        

        specify do
          clazz.action(event).path.should == default_path
        end        

        specify do
          clazz.action(event, 'other_path').path.should == 'other_path'
        end        
      end
    end
  end  
end