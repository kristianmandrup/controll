require 'spec_helper'

class MySweetController
  include Controll::Enabler

  def fallback_path
    'root'
  end

  def away
    'away'
  end

  def perfect
    'perfect'
  end
end

ActionMapper = Controll::Flow::ActionMapper
Action = Controll::Flow::Action

class Redirecter < ActionMapper::Complex
  event_map 'inperfect' => [:cool, :sweet], 'away' => [:success]
end

class Renderer < ActionMapper::Simple
  events %w{perfect}
end

describe Controll::Enabler::PathResolver do
  def notice name
    Hashie::Mash.new(name: name.to_sym, type: :notice)
  end

  def error name
    Hashie::Mash.new(name: name.to_sym, type: :error)
  end

  let(:controller) { MySweetController.new }

  let(:render_map)    { {'perfect' => [:cool, :sweet], 'home' => [:success] }}
  let(:redirect_map)  { {'inperfect' => [:cool, :sweet], 'away' => [:success] } }

  let(:fallback_action) { Action::Fallback.new controller }

  context 'initialize controller, render_map' do
    subject { Controll::Enabler::PathResolver.new controller, render_map }

    its(:caller)      { should == controller }
    its(:controller)  { should == controller }
    its(:event_map)   { should == render_map }

    describe '.resolve' do
      specify do
        subject.resolve.should == 'home'
      end
      
      describe '.resolve :cool' do
        specify do
          subject.resolve(:cool).should == 'perfect'
        end
      end

      describe '.resolve sweet' do
        specify do
          subject.resolve(:sweet).should == 'perfect'
        end
      end

      describe '.resolve :uncool' do
        specify do
          subject.resolve(:uncool).should_not == 'perfect'
        end

        specify do
          subject.resolve(:uncool).should == nil
        end
      end

      describe '.resolve Fallback Action' do
        specify do
          subject.resolve(fallback_action).should == nil
        end
      end
    end
  end
end
