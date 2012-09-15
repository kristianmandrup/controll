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
end

class Renderer < ActionMapper::Simple
end

describe Controll::Enabler::PathResolver do
  let(:controller) { MySweetController.new }

  let(:render_map)    { {'perfect' => [:cool, :sweet], 'home' => [:success] }}
  let(:redirect_map)  { {'inperfect' => [:cool, :sweet], 'away' => [:success] }}

  let(:redirect_action) { ActionMapper::Simple.action controller, redirect_path }
  let(:render_action)   { ActionMapper::Simple.action controller, render_path }
  let(:fallback_action) { Action::Fallback.new controller }

  let(:render_path) { 'perfect' }
  let(:redirect_path) { 'away' }

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

      describe '.resolve Render Action' do
        specify do
          subject.resolve(render_action).should == render_path
        end
      end

      describe '.resolve Redirect Action' do
        specify do
          subject.resolve(redirect_action).should == redirect_path
        end
      end
    end
  end
end
