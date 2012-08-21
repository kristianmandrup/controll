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

module Flows
  class EmptyEvent < Master
    def event
    end
  end

  class UpdateEventWithoutHandler < Master
    def event
      :update
    end
  end


  class UpdateEvent < Master
    def event
      :update
    end

    renderer :simple do
      events :update
      default_path 'default'
    end
  end

  class UpdateEventNoMatch < Master
    def event
      :update
    end

    renderer :simple do
      events :create
      default_path '/default'
    end
  end
end

ActionMapper = Controll::Flow::ActionMapper

Action = ActionMapper::Action
PathAction = ActionMapper::PathAction
Fallback = ActionMapper::Fallback
Simple = ActionMapper::Simple
Complex = ActionMapper::Complex

describe Controll::Flow::Master do
  context 'use directly without sublclassing' do
    subject { flow.new controller }

    let(:flow)  { Controll::Flow::Master }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do
      specify do
        expect { subject.execute }.to raise_error(Controll::Flow::EventNotImplementedError)
      end
    end
  end

  context 'A Control Flow with empty #event method' do
    subject { flow.new controller }

    let(:flow)  { Flows::EmptyEvent }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      specify do
        expect { subject.execute }.to_not raise_error
      end

      # since event returns nil
      specify do
        subject.execute.should_not be_nil
      end
    end
  end

  context 'A Control Flow where #event returns :update notice event' do
    subject { flow.new controller }

    let(:flow)  { Flows::UpdateEventWithoutHandler }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      # since event returns nil
      specify do
        subject.execute.should be_a Fallback
      end
    end
  end  

  context 'A Control Flow where #event returns :update notice event and has a Render class with matching mapping' do
    subject { flow.new controller }

    let(:flow)  { Flows::UpdateEvent }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      # since event returns nil
      specify do
        expect { subject.execute }.to_not raise_error(Controll::Flow::ActionEventError)
      end

      specify do
        subject.execute.should be_a Fallback
      end
    end
  end  

  context 'A Control Flow where #event returns :update notice event and has a Render class with NO matching mapping' do
    subject { flow.new controller }

    let(:flow)  { Flows::UpdateEventNoMatch }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      # since event returns nil
      specify do
        expect { subject.execute }.to_not raise_error
      end
    end
  end  

end