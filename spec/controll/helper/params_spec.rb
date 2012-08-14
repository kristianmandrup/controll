require 'spec_helper'

class Parameters
  include Controll::Helper::Params

  attr_reader :params

  def initialize params = nil
    @params = params || {name: 'kris', shoe_size: 43, gender: 'male' }
  end
end

describe Controll::Helper::Params do

  subject { clazz.new }
  let(:clazz) { Parameters }

  describe '.param_methods *args' do
    before :all do
      clazz.param_methods :name, :shoe_size
      clazz.param_method  :gender
    end

    its(:name)      { should == 'kris' }
    its(:shoe_size) { should == 43 }
    its(:gender)    { should == 'male' }
  end
end