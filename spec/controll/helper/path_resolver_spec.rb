require 'spec_helper'

class MySweetController
  include Controll::Helper

  redirect_map :index => %w{success}

  render_map :show => %w{success}

  # Mocking!
  def render path
    path
  end
  alias_method :redirect_to, :render
end

describe Controll::Helper::PathResolver do
  subject { Controll::Helper::PathResolver.new controller }

  let(:controller) { MySweetController.new }

  describe '.extract_path' do
    describe ':redirect_map' do
      specify do
        subject.extract_path(:redirect_map).should == 'index'
      end
    end

    describe ':render_paths' do
      specify do
        subject.extract_path(:render_paths).should == 'show'
      end
    end
  end

  describe '.resolve_path' do
    describe ':redirect_map' do
      specify do
        subject.resolve_path(:redirect_map).should == 'index'
      end
    end

    describe ':render_paths' do
      specify do
        subject.resolve_path(:render_paths).should == 'show'
      end
    end
  end
end
