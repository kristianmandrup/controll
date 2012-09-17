require 'spec_helper'

class HelloToWelcomeRedirect < Controll::Flow::ActionMapper::Complex
  event_map :welcome => [:hello, :hi]
end

class ErrorBadRedirect < Controll::Flow::ActionMapper::Complex  
  event_map :error, bad: ['bad_payment', 'wrong_payment']
end

class TheController
end

describe Controll::Flow::ActionMapper::Complex do

  def notification name
    Hashie::Mash.new(name: name.to_sym, type: :notice)
  end

  def error name
    Hashie::Mash.new(name: name.to_sym, type: :error)
  end

  let(:controller) { TheController.new }

  describe 'class macros' do
    before :all do
      ErrorBadRedirect.event_map :error, crap: ['bad_payment', 'wrong_payment']
    end

    specify {
      ErrorBadRedirect.event_map_for(:error).should == {crap: ['bad_payment', 'wrong_payment']}
    }

    specify {
      ErrorBadRedirect.event_maps.should == {error: {crap: ['bad_payment', 'wrong_payment']} }
    }
  end

  context 'use directly without subclassing' do
    subject { clazz.new '/' }

    let(:clazz) { Controll::Flow::ActionMapper::Complex }

    let(:hello) { notification :hello }

    describe '.action event' do
      specify do
        expect { clazz.action(controller, :hello) }.to raise_error(Controll::Flow::NoMappingFoundError)
      end
    end
  end

  context 'HelloToWelcomeRedirect subclass' do
    subject { clazz.new '/' }

    let(:clazz) { HelloToWelcomeRedirect }

    context 'has redirections' do
      describe '.action event' do
        specify do
          expect { clazz.action(controller, :hello) }.to_not raise_error(Controll::Flow::NoMappingFoundError)
        end

        specify do
          clazz.action(controller, :hello).should be_a Controll::Flow::Action::PathAction
        end

        specify do
          clazz.action(controller, :hi).path.should == 'welcome'
        end
      end
    end
  end

  context 'ErrorBadRedirect subclass' do
    subject { clazz.new '/' }

    let(:clazz) { ErrorBadRedirect }

    before do
      Controll::Event.reset_types
    end

    context 'has error redirections' do
      describe '.action event' do
        specify do
          expect { clazz.action(controller, :hello) }.to raise_error(Controll::Flow::NoMappingFoundError)
        end

        specify do
          clazz.action(controller, error(:bad_payment)).should be_a Controll::Flow::Action::PathAction
        end

        specify do
          clazz.action(controller, error(:wrong_payment)).path.should == 'crap'
        end
      end
    end
  end

end