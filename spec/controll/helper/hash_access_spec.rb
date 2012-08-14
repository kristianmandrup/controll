require 'spec_helper'

class Hasher
  include Controll::Helper::HashAccess  

  attr_reader :params

  def initialize params = nil
    @params = params || {name: 'kris'}
  end
end

describe Controll::Helper::HashAccess do

  subject { clazz.new }
  let(:clazz) { Hasher }

  describe '.hash_access_methods *args' do
    before :all do
      clazz.hash_access_methods :name, hash: :params
    end

    specify { subject.name.should == 'kris' }
  end
end