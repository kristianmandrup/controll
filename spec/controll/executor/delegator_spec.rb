require 'spec_helper'

class MyDelegator < Controll::Executor::Delegator
end

class MyAwesomeController
  def hello
    "hello"
  end
end

describe Controll::Executor::Delegator do
  subject { MyDelegator.new controller }

  let(:controller) { MyAwesomeController.new }

  describe '.method_missing' do
    specify do
      subject.hello.should == 'hello'
    end

    specify do
      expect { subject.bye }.to raise_error
    end
  end
end