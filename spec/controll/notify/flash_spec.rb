require 'spec_helper'

class MockController
  def flash
    @flash ||= Hash.new
  end
end

describe Controll::Notify::Flash do
  subject { Controll::Notify::Flash.new MockController.new }

  describe 'class methods' do
    subject { Controll::Notify::Flash }

    describe '.types' do
      its(:types) { should include(:notice, :warning) }
    end

    describe '.add_types' do
      before do
        subject.add_types :payment, :help
      end

      its(:types) { should include(:payment, :help) }
    end
  end
end