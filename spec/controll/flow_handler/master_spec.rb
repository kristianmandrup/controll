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

module FlowHandlers
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



describe Controll::FlowHandler::Master do
  context 'use directly without sublclassing' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { Controll::FlowHandler::Master }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do
      specify do
        expect { subject.execute }.to raise_error(Controll::FlowHandler::EventNotImplementedError)
      end
    end
  end

  context 'A Control FlowHandler with empty #event method' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { FlowHandlers::EmptyEvent }
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

    let(:flow_handler)  { FlowHandlers::UpdateEventWithoutHandler }
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

    let(:flow_handler)  { FlowHandlers::UpdateEvent }
    let(:controller)    { MyController::Update.new }

    describe '.initialize' do
      specify do
        subject.controller.should == controller
      end
    end

    describe '.execute' do    
      # since event returns nil
      specify do
        expect { subject.execute }.to_not raise_error(Controll::FlowHandler::ActionEventError)
      end

      specify do
        subject.execute.should_not be_nil
      end
    end
  end  

  context 'A Control FlowHandler where #event returns :update notice event and has a Render class with NO matching mapping' do
    subject { flow_handler.new controller }

    let(:flow_handler)  { FlowHandlers::UpdateEventNoMatch }
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