require 'spec_helper'

class BasicFallback < Controll::FlowHandler::Fallback
  def perform
    'hello'
  end
end

describe Controll::FlowHandler::Fallback do
  context 'override perform' do
    subject { clazz.new '/' }

    let(:clazz) { BasicFallback }

    describe '.action event' do
      specify do
        clazz.action(:hello).should be_a Controll::FlowHandler::Fallback
      end
    end

    describe '.perform' do
      specify do
        clazz.action(:hello).perform.should == 'hello'
      end
    end
  end
end