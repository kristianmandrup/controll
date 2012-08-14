require 'spec_helper'

module MyController
  class Update
  end
end

class UpdateFlowHandler < Controll::FlowHandler::Control
  def event
  end
end

describe Controll::FlowHandler::Control do
  context 'use directly without sublclassing' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { Controll::FlowHandler::Control }
    let(:controller)    { MyController::Update }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do
      specify do
        expect { subject.execute }.to raise_error(NotImplementedError)
      end
    end
  end

  context 'A valid Control FlowHandler' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { UpdateFlowHandler }
    let(:controller)    { MyController::Update }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      specify do
        expect { subject.execute }.to_not raise_error(NotImplementedError)
      end
    end

  end
end