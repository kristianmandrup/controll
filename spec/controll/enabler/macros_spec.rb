require 'spec_helper'

class MyController
  include Controll::Enabler::Macros

  # Mocking!
  def render path
    path
  end
  alias_method :redirect_to, :render  
end

module Executors
  class Services < Controlled
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
  class Services < Assistant
  end
end

module Flows
  class Services < Master
  end
end

describe Controll::Enabler do
  subject { controller.new }
  let(:controller) { MyController }

  describe 'class level macros' do

    describe '.commander name, options = {}' do
      before :all do
        controller.commander :services
      end

      its(:commander) { should be_a Commanders::Services }
    end

    describe '.commander name, options = {}' do
      before :all do
        controller.notifier :services
      end

      its(:notifier) { should be_a Notifiers::Services }
    end

    describe '.assistant name, options = {}' do
      before :all do
        controller.assistant :services
      end

      its(:assistant) { should be_a Assistants::Services }
    end

    describe '.flow name, options = {}' do
      before :all do
        controller.flow :services
      end

      its(:flow) { should be_a Flows::Services }
    end
  end
end