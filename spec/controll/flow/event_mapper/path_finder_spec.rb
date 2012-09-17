require 'spec_helper'

describe Controll::Flow::EventMapper::PathFinder do
  def notice name
    Hashie::Mash.new(name: name.to_sym, type: :notice)
  end

  def error name
    Hashie::Mash.new(name: name.to_sym, type: :error)
  end

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
    let(:clazz)       { Controll::Flow::EventMapper::PathFinder }
    let(:hello)       { notice :hello }
    let(:bad_payment) { error :bad_payment }

    describe '.action event' do
      subject { clazz.new hello, redirections, types  }

      specify do
        expect { subject.map }.to_not raise_error(Controll::Flow::NoMappingFoundError)
      end

      specify do
        subject.path.should == 'welcome'
      end
    end
  end
end