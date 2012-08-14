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

class EmptyEventFlowHandler < Controll::FlowHandler::Control
  def event
  end
end

class UpdateEventWithoutHandlerMapping < Controll::FlowHandler::Control
  def event
    :update
  end
end

class UpdateEventFlowHandler < Controll::FlowHandler::Control
  def event
    :update
  end

  class Render < Controll::FlowHandler::Render
    set_events :update
    set_default_path 'default'
  end
end

class UpdateEventNoMatchFlowHandler < Controll::FlowHandler::Control
  def event
    :update
  end

  class Render < Controll::FlowHandler::Render
    set_events :create
    set_default_path '/default'
  end
end



describe Controll::FlowHandler::Control do
  context 'use directly without sublclassing' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { Controll::FlowHandler::Control }
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
    end
  end

  context 'A Control FlowHandler with empty #event method' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { EmptyEventFlowHandler }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      specify do
        expect { subject.execute }.to_not raise_error(NotImplementedError)
      end

      # since event returns nil
      specify do
        expect { subject.execute }.to_not raise_error
      end
    end
  end

  context 'A Control FlowHandler where #event returns :update notice event' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { UpdateEventWithoutHandlerMapping }
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

  context 'A Control FlowHandler where #event returns :update notice event and has a Render class with matching mapping' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { UpdateEventFlowHandler }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      # since event returns nil
      specify do
        expect { subject.execute }.to_not raise_error(Controll::FlowHandler::Control::ActionEventError)
      end

      specify do
        subject.execute
        subject.executed?.should be_true
      end
    end
  end  

  context 'A Control FlowHandler where #event returns :update notice event and has a Render class with NO matching mapping' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { UpdateEventNoMatchFlowHandler }
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