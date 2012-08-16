require 'spec_helper'

def notice name
  Hashie::Mash.new(name: name.to_sym, type: :notice)
end

def error name
  Hashie::Mash.new(name: name.to_sym, type: :error)
end

describe Controll::FlowHandler::Redirect::Mapper do
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

    let(:clazz)         { Controll::FlowHandler::Redirect::Mapper }
    let(:hello)         { notice :hello }
    let(:bad_payment)   { error :bad_payment }

    describe '.initialize' do
      its(:event) { should == hello }
      its(:redirect_map) { should == notice_map }
    end

    describe '.map' do
      specify do
        subject.map.should == 'welcome'
      end
    end

    describe '.matcher event' do
      specify do
        subject.send(:matcher, hello).should be_a Controll::Helper::EventMatcher
      end      

      specify do
        subject.send(:matcher, hello).event.should == hello
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