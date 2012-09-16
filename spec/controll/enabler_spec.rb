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
    describe 'do_redirect' do
      specify do
        expect { subject.do_redirect }.to raise_error(ArgumentError)
      end
    end

    describe 'do_render' do
      specify do
        expect { subject.do_render }.to raise_error(ArgumentError)
      end
    end
  end
end