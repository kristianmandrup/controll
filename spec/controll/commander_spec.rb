require 'spec_helper'

class NiceController
  def flash
    @flash ||= Hash.new
  end
end

describe Controll::Commander do
  context 'class methods' do
    subject { Controll::Commander }
  end

  context 'Commander instance' do
    subject { Controll::Commander.new controller, options }

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
    end

    describe '.command! name, *args' do
    end

    describe '.use_command (alias: command!)' do
    end
  end
end