require 'spec_helper'

class Sessione
  include Controll::Helper::Session

  attr_reader :session

  def initialize session = nil
    @session = session || {name: 'kris', shoe_size: 43, gender: 'male' }
  end
end

describe Controll::Helper::Params do

  subject { clazz.new }
  let(:clazz) { Sessione }

  describe '.session_methods *args' do
    before :all do
      clazz.session_methods :name, :shoe_size
      clazz.session_method  :gender
    end

    its(:name)      { should == 'kris' }
    its(:shoe_size) { should == 43 }
    its(:gender)    { should == 'male' }
  end
end