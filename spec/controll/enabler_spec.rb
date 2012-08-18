require 'spec_helper'

class MyController
  include Controll::Helper

  # Mocking!
  def render path
    path
  end
  alias_method :redirect_to, :render  
end

module Executors
  class Custom < Notificator
  end
end

module Commanders
  class Services < Commander
  end
end

module Notifiers
  class Services < Typed
  end
end

module Assistants
  class Service < Assistant
  end
end

module Assistants
  class ServiceDelegate < DelegateAssistant
  end
end

module FlowHandlers
  class CreateService < Control
  end
end

describe Controll::Helper do
  subject { controller.new }
  let(:controller) { MyController }

  describe 'class level macros' do

    describe '.commander name, options = {}' do
      before :all do
        controller.commander :service
      end

      its(:commander) { should be_a ServiceCommander }
    end

    describe '.commander name, options = {}' do
      before :all do
        controller.message_handler :service
      end

      its(:message_handler) { should be_a ServiceMessageHandler }
    end

    describe '.assistant name, options = {}' do
      before :all do
        controller.assistant :service
      end

      its(:assistant) { should be_a ServiceAssistant }
    end

    describe '.delegate_assistant name, options = {}' do
      before :all do
        controller.delegate_assistant :service
      end

      its(:assistant) { should be_a ServiceDelegateAssistant }
    end


    describe '.flow_handler name, options = {}' do
      before :all do
        controller.flow_handler :service
      end

      its(:flow_handler) { should be_a ServiceFlowHandler }
    end

    describe '.redirect_map {}' do
      before :all do
        controller.redirect_map :index => %w{alpha beta}
      end

      its(:redirect_map) { should == {:index => ['alpha', 'beta'] } }
    end

    describe '.redirect_map {}' do
      before :all do
        controller.render_map :index => %w{alpha beta}
      end

      its(:render_paths) { should == {:index => ['alpha', 'beta'] } }
    end
  end

  context 'instance' do
    describe 'do_redirect *args' do
      specify do
        subject.do_redirect.should == nil
      end
    end

    describe 'do_render *args' do
      specify do
        subject.do_render.should == nil
      end
    end
  end
end