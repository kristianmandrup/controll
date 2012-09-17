require 'spec_helper'

class FallbackController
  def do_fallback fallback
    "did a nice fallback :) - #{fallback.event.name}"
  end
end

class BasicFallbackAction < Controll::Flow::Action::Fallback
end

describe Controll::Flow::Action::Fallback do
  context 'Basic default fallback' do
    subject { clazz.new controller, event }

    let(:controller)  { FallbackController.new }
    let(:clazz)       { BasicFallbackAction }
    let(:event)       { create_event :unknown, :notice }

    include Controll::Event::Helper

    describe '.action controller, event' do
      specify do
        clazz.action(controller, event).should be_a Controll::Flow::Action::Fallback
      end
    end

    describe '.perform' do
      specify do
        clazz.action(controller, event).perform.should == "did a nice fallback :) - #{event.name}"
      end
    end
  end
end