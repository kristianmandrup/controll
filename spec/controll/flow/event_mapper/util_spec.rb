require 'spec_helper'

def notice name
  Hashie::Mash.new(name: name.to_sym, type: :notice)
end

def error name
  Hashie::Mash.new(name: name.to_sym, type: :error)
end

describe Controll::Flow::EventMapper::Util do
  let(:redirections) do
    { 
      :error => error_map, :notice => notice_map
    }
  end

  let(:notice_map)  do
    {:welcome =>  valid_events }
  end

  let(:valid_events) { [:hello, :hi] }
  let(:invalid_events) { [:blip, :blap] }

  let(:error_map)  do
    {bad: ['bad_payment', 'wrong_payment'] }
  end

  let(:types) { [:notice, :error] }

  context 'use' do    
    subject { clazz.new hello, notice_map }

    let(:clazz)         { Controll::Flow::EventMapper::Util }
    let(:hello)         { notice :hello }
    let(:bad_payment)   { error :bad_payment }

    describe '.initialize' do
      its(:event) { should be_a Controll::Event }
      its(:event_map) { should == notice_map }
    end

    describe '.map_event' do
      specify do
        subject.map_event.should == 'welcome'
      end
    end

    describe '.matcher' do
      specify do
        subject.send(:matcher).should be_a Controll::Event::Matcher
      end      

      specify do
        subject.send(:matcher).event.should be_a Controll::Event
      end      
    end

    describe '.valid?' do
      specify do
        subject.send(:valid?, valid_events).should be_true
      end

      specify do
        subject.send(:valid?, invalid_events).should be_false
      end
    end
  end
end