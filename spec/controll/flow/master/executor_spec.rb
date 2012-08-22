require 'spec_helper'

module MyController
  class Update
    def render path
      send(path) if path
    end

    def default
      'default'
    end
  end
end

describe Controll::Flow::Master::Executor do
  include Controll::Event::Helper

  let(:executor)        { Controll::Flow::Master::Executor }
  let(:controller)      { MyController::Update.new }

  let(:fallback_event)  { create_event :unknown, :notice }
  let(:render_event)    { create_event :hello,   :notice }
  let(:redirect_event)  { create_event :exit,    :error }

  let(:action_handlers) { [:renderer, :redirecter] }

  let(:options) do
    {event: event, action_handlers: action_handlers}
  end

  describe '.initialize controller, fallback_event' do
    let(:event) { fallback_event }
    subject { executor.new controller, options }

    specify do
      subject.controller.should == controller
    end

    specify do
      subject.event.should == event
    end
  end

  describe '.initialize controller, render_event' do
    let(:event) { render_event }
    subject { executor.new controller, options }

    specify do
      subject.controller.should == controller
    end

    specify do
      subject.event.should == event
    end
  end
end