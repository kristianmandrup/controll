require 'spec_helper'

class Container
  include Controll::Event::Helper  
end

describe Controll::Event::Helper do
  subject { Container.new }

  let(:events)      { %w{sign_in sign_out} }
  let(:bad_events)  { %w{bad stuff} }

  let(:event)       { 'sign_in' }
  let(:bad_event)   { 'unknown' }

  describe '.normalize event' do
    context 'Controll::Event' do
      specify { subject.normalize(Controll::Event.new(:x)).should be_a Controll::Event  }
    end

    context 'Symbol' do
      specify { subject.normalize(:x).should be_a Controll::Event  }
    end

    context 'Hash' do
      specify { subject.normalize(:name => :y).should be_a Controll::Event  }
    end    
  end

  describe '.create_event' do
    specify { subject.create_event(:x).should be_a Controll::Event }
  end
end