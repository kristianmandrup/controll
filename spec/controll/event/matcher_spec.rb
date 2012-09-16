require 'spec_helper'

describe Controll::Event::Matcher do
  subject { Controll::Event::Matcher.new event }

  let(:events)      { %w{sign_in sign_out} }
  let(:bad_events)  { %w{bad stuff} }

  let(:event)       { 'sign_in' }
  let(:bad_event)   { 'unknown' }

  describe '.initialize event' do
    its(:event) { should be_a Controll::Event }
    its('event.name') { should == :sign_in }
  end

  describe '.match? events' do
    specify { subject.match?(events).should be_true }

    specify { subject.match?(bad_events).should be_false }
  end
end