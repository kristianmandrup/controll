require 'spec_helper'

class NiceController
  def flash
    @flash ||= Hash.new
  end
end

class SignInCommand < Imperator::Command
  def perform
    'signed_in'
  end
end

class NiceCommander < Controll::Commander
  command_method(:sign_in, name: 'kris') { {id: id} }

  def id
    'my id'
  end
end

describe Controll::Commander do
  context 'class methods' do
    subject { Controll::Commander }
  end

  context 'Commander instance' do
    subject { commander_clazz.new controller, options }
    let(:commander_clazz) { NiceCommander }

    let(:controller) { NiceController.new }
    let(:options) do
      {name: 'nice' }
    end

    # attr_reader :controller, :options

    describe '.initialize controller, options = {}' do
      its(:controller) { should == controller }
      its(:options) { should == options }
    end

    describe '.command name, *args' do 
      specify do
        subject.command(:sign_in).should be_a Imperator::Command
      end
    end

    describe '.command! name, *args' do
      specify do
        subject.command!(:sign_in).should == 'signed_in'
      end
    end

    describe '.use_command (alias: command!)' do
      specify do
        subject.use_command(:sign_in).should == 'signed_in'
      end
    end

    describe '.perform_command (alias: command!)' do
      specify do
        subject.perform_command(:sign_in).should == 'signed_in'
      end
    end
  end
end