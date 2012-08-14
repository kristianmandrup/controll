require 'spec_helper'

require 'spec_helper'

class HelloToWelcomeRedirect < Controll::FlowHandler::Redirect
  def self.redirections
    {:hello => 'welcome'}
  end
end

class HiRedirect < Controll::FlowHandler::Redirect
  def self.events
    [:hi]
  end
end

class HelloRedirect < Controll::FlowHandler::Redirect
  def self.events
    [:hello]
  end  
end

def notification name
  Hashie::Mash.new(name: name.to_sym, type: :notification)
end

describe Controll::FlowHandler::Redirect do

  context 'use directly without sublclassing' do
    subject { clazz.new '/' }

    let(:clazz) { Controll::FlowHandler::Redirect }

    let(:hello) { notification :hello }

    describe '.action event' do
      specify do
        expect { clazz.action(:hello) }.to raise_error(Controll::FlowHandler::Redirect::NoRedirectionFoundError)
      end
    end
  end

  context 'HelloToWelcomeRedirect subclass' do
    subject { clazz.new '/' }

    let(:clazz) { HelloToWelcomeRedirect }

    context 'empty events' do
      describe '.action event' do
        specify do
          expect { clazz.action(:hello) }.to_not raise_error(Controll::FlowHandler::Redirect::NoRedirectionFoundError)
        end

        specify do
          clazz.action(:hello).should be_a HelloToWelcomeRedirect
        end
      end
    end
  end

  # context 'HiRedirect subclass' do
  #   subject { clazz.new '/' }

  #   let(:clazz) { HiRedirect }
  #   let(:event) { notification :hello }

  #   context 'has events' do
  #     describe '.action event' do

  #       describe 'does not respond to hello' do
  #         specify do
  #           expect { clazz.action(:hello) }.to_not raise_error(Controll::FlowHandler::Redirect::NoEventsDefinedError)
  #         end

  #         specify do
  #           clazz.action(event).should == nil
  #         end

  #         specify do
  #           clazz.action(:hello).should == nil
  #         end
  #       end

  #       describe 'responds to hi' do
  #         # default_path not implemented!
  #         specify do
  #           expect { clazz.action(:hi) }.to raise_error NotImplementedError
  #         end
  #       end
  #     end
  #   end
  # end

  # context 'HelloRedirect subclass' do
  #   subject { clazz.new default_path }

  #   let(:clazz) { HelloRedirect }
  #   let(:event) { notification :hello }
  #   let(:default_path) { '/default' } 

  #   context 'has events and default_path' do
  #     describe '.action event' do
  #       specify do
  #         clazz.action(event).should be_a HelloRedirect
  #       end        

  #       specify do
  #         clazz.action(event).path.should == default_path
  #       end        

  #       specify do
  #         clazz.action(event, 'other_path').path.should == 'other_path'
  #       end        
  #     end
  #   end
  # end  
end