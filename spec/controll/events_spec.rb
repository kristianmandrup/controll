require 'spec_helper'

describe Controll::Events do
  subject { clazz.new }
  let(:clazz) { Controll::Events }

  include Controll::Event::Helper

  let(:a_success) { create_event :success } 
  let(:a_warning) { create_event :warning }

  describe 'class methods' do
    subject { clazz }  

    its(:valid_types) { should == Controll::Event.valid_types }
  end

  describe 'last' do
    subject { Controll::Events.new a_success, a_warning }  

    its(:last) { should == a_warning }
  end
end