require 'spec_helper'

class SessionAssistant < Controll::SessionAssistant
  session_methods :name
end

class MyController
  include Controll::SessionAssistant::Helper

  def session
    {:name => 'kris'}
  end

  session_assistant ::SessionAssistant
end

describe Controll::Assistant do
  context 'Session assistant' do
    subject { SessionAssistant.new controller }

    let(:controller) { MyController.new }

    its(:controller) { should == controller }
    its(:session) { should == {:name => 'kris'} }
    its(:name) { should == 'kris' }

    specify do
      controller.sess(:name).should == 'kris'
    end
  end
end