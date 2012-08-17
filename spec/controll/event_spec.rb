require 'spec_helper'

describe Controll::Event do
  let(:clazz) { Controll::Event }

  describe '.initialize name, *args' do
    context 'implicit notice' do
      subject { Controll::Event.new 'sign_in' }  

      its(:name)    { should == :sign_in }
      its(:type)    { should == :notice }
      its(:options) { should be_blank }
    end

    context 'explicit notice' do
      subject { Controll::Event.new 'sign_in', :notice }  

      its(:name)    { should == :sign_in }
      its(:type)    { should == :notice }
      its(:options) { should be_blank }
    end

    context 'explicit error and options' do
      subject { Controll::Event.new 'sign_in', :error, {:a => 7} }  

      its(:name)    { should == :sign_in }
      its(:type)    { should == :error }
      its(:options) { should == {:a => 7} }
    end

    context 'explicit warning type in options' do
      subject { Controll::Event.new 'sign_in', {:type => :warning, :a => 7} }  

      its(:name)    { should == :sign_in }
      its(:type)    { should == :warning }
      its(:options) { should == {:a => 7} }

      describe '.warning?' do
        its(:warning?) { should be_true }
        its(:notice?) { should be_false }
      end
    end
  end

  context 'class methods' do
    subject { clazz }

    describe '.valid_types' do
      its(:valid_types) { should = %w{notice error warning success} }
    end

    describe '.valid_types=' do
      before do
        clazz.valid_types = [:notice]
      end
      its(:valid_types) { should = [:notice] }
    end

    describe '.add_valid_type' do
      before do
        clazz.add_valid_types :remote, :invalid
      end
      its(:valid_types) { should include(:remote, :invalid) }
    end
  end
end