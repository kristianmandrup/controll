require 'spec_helper'

class MyAssistant < Controll::Assistant
  controller_methods :params
end

class MyController
  def params
    {:id => 7}
  end

  def my_assistant
    @my_assistant ||= MyAssistant.new self
  end
end

describe Controll::Assistant do
  context 'My assistant with params delegation' do
    subject { MyAssistant.new controller }

    let(:controller) { MyController.new }

    its(:controller) { should == controller }
    its(:params) { should == {:id => 7} }
  end
end