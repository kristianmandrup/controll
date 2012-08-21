require 'spec_helper'

class HelloToWelcomeRedirect < Controll::Flow::Redirect
  set_redirections :welcome => [:hello, :hi]
end

class ErrorBadRedirect < Controll::Flow::Redirect  
  set_redirections :error, bad: ['bad_payment', 'wrong_payment']
end

def notification name
  Hashie::Mash.new(name: name.to_sym, type: :notice)
end

def error name
  Hashie::Mash.new(name: name.to_sym, type: :error)
end

describe Controll::Flow::Redirect do

  describe 'class macros' do
    before :all do
      ErrorBadRedirect.set_redirections :error, crap: ['bad_payment', 'wrong_payment']
    end

    specify {
      ErrorBadRedirect.redirections_for(:error).should == {crap: ['bad_payment', 'wrong_payment']}
    }

    specify {
      ErrorBadRedirect.redirections.should == {error: {crap: ['bad_payment', 'wrong_payment']} }
    }
  end

  context 'use directly without subclassing' do
    subject { clazz.new '/' }

    let(:clazz) { Controll::Flow::Redirect }

    let(:hello) { notification :hello }

    describe '.action event' do
      specify do
        expect { clazz.action(:hello) }.to raise_error(Controll::Flow::Redirect::NoRedirectionFoundError)
      end
    end
  end

  context 'HelloToWelcomeRedirect subclass' do
    subject { clazz.new '/' }

    let(:clazz) { HelloToWelcomeRedirect }

    context 'has redirections' do
      describe '.action event' do
        specify do
          expect { clazz.action(:hello) }.to_not raise_error(Controll::Flow::Redirect::NoRedirectionFoundError)
        end

        specify do
          clazz.action(:hello).should be_a HelloToWelcomeRedirect
        end

        specify do
          clazz.action(:hi).path.should == 'welcome'
        end
      end
    end
  end

  context 'ErrorBadRedirect subclass' do
    subject { clazz.new '/' }

    let(:clazz) { ErrorBadRedirect }

    context 'has error redirections' do
      describe '.action event' do
        specify do
          expect { clazz.action(:hello) }.to raise_error(Controll::Flow::NoRedirectionFoundError)
        end

        specify do
          clazz.action(error :bad_payment).should be_a ErrorBadRedirect
        end

        specify do
          clazz.action(error :wrong_payment).path.should == 'crap'
        end
      end
    end
  end

end