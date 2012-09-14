require 'spec_helper'

class MyControlledExec < Controll::Executor::Controlled
end

class MyAwesomeController
  def hello
    "hello"
  end
end

describe Controll::Executor::Controlled do
  subject { MyControlledExec.new controller }

  let(:controller) { MyAwesomeController.new }

  describe '.method_missing' do
    specify do
      subject.hello.should == 'hello'
    end

    specify do
      expect { subject.bye }.to raise_error
    end
  end

  describe '.execute' do
  end

  describe '.result' do
  end

  describe 'self.execute &block' do
  end  
end