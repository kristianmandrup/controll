require 'spec_helper'


class MyExec < Controll::Executor::Notificator
end

class MyAwesomeController
  def hello
    "hello"
  end
end

describe Controll::Executor::Notificator do
  subject { MyExec.new controller }

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