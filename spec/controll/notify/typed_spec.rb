require 'spec_helper'
require 'controll/notify/services_notifier'

class MyController
  attr_reader :flash

  def initialize
    @flash = {}
  end
end

describe Controll::Notify::Typed do
  subject { Notifiers::Services.new controller }

  let(:controller) { MyController.new }

  describe 'notice' do
    specify do
      subject.notice.hello.should == 'hello you'
    end
  end

  describe 'error' do
    specify do
      subject.error.bad.should == 'bad stuff!'
    end
  end
end