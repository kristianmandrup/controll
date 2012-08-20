require 'spec_helper'

class ParamAssistant < Controll::ParamAssistant
  param_methods :id
end

class MyController
  include Controll::ParamAssistant::Helper

  def params
    {:id => 7}
  end

  param_assistant ::ParamAssistant
end

describe Controll::Assistant do
  context 'Param assistant' do
    subject { ParamAssistant.new controller }

    let(:controller) { MyController.new }

    its(:controller) { should == controller }
    its(:params) { should == {:id => 7} }
    its(:id) { should == 7 }

    specify do
      controller.param(:id).should == 7
    end
  end
end