require 'spec_helper'

class NiceController
  def flash
    @flash ||= Hash.new
  end
end

class SignInCommand < Controll::Command
  attribute :parent_id, String

  def perform
    {id: params[:id], parent: parent_id, user_id: session[:user_id] }
  end
end

class NiceCommander < Controll::Commander
  command_method(:sign_in, name: 'kris') { {parent_id: parent_id} }

  def params
    {:id => 7}
  end

  def session
    {:user_id => 1}
  end

  def parent_id
    'my parent'
  end
end

describe Controll::Command do

  context 'Commander instance' do
    subject { commander_clazz.new controller, options }
    let(:commander_clazz) { NiceCommander }

    let(:controller) { NiceController.new }
    let(:options) do
      {name: 'nice' }
    end

    describe '.command name, *args' do 
      specify do
        subject.command(:sign_in).should be_a Controll::Command
      end
    end

    describe '.command! name, *args' do
      specify do
        subject.command!(:sign_in).should == {id: 7, parent: 'my parent', user_id: 1 }
      end
    end
  end
end