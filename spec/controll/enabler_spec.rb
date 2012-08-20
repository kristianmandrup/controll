require 'spec_helper'

class MyController
  include Controll::Enabler

  # Mocking!
  def render path
    path
  end
  alias_method :redirect_to, :render  
end

describe Controll::Enabler do
  subject { controller.new }
  let(:controller) { MyController }

  context 'instance' do
    describe 'do_redirect *args' do
      specify do
        subject.do_redirect.should == nil
      end
    end

    describe 'do_render *args' do
      specify do
        subject.do_render.should == nil
      end
    end
  end
end