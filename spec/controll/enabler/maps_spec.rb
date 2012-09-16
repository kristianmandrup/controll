require 'spec_helper'

class SweetController
  include Controll::Enabler::Maps
end

describe Controll::Enabler::Maps do
  subject { controller.new }

  let(:controller) { SweetController }

  describe '.redirect_map {}' do
    before :all do
      controller.redirect_map :index => %w{alpha beta}
    end

    specify do
      controller.redirect_map.should == {:index => ['alpha', 'beta'] }
    end
  end

  describe '.render_map {}' do
    before :all do
      controller.render_map :index => %w{alpha zeta}
    end

    specify do
      controller.render_map.should == {:index => ['alpha', 'zeta'] }
    end
  end
end
