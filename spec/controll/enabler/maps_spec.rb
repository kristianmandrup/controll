describe Controll::Enabler::Maps do
  subject { controller.new }
  let(:controller) { MyController }

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
      controller.render_map :index => %w{alpha beta}
    end

    its(:render_paths) { should == {:index => ['alpha', 'beta'] } }
  end
end
