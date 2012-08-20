require 'spec_helper'

class MySweetController
  include Controll::Enabler

  redirect_map :index => %w{success}

  render_map :show => %w{success}

  # Mocking!
  def render path
    path
  end
  alias_method :redirect_to, :render
end

describe Controll::Enabler::PathHandler do
  subject { Controll::Enabler::PathHandler.new controller }

  let(:controller) { MySweetController.new }

  describe '.path_for action' do
end