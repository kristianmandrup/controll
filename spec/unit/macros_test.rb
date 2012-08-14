require 'helper'

class ApplicationController
end

require 'focused_controller/macros'

class MyBaseAction < ::FocusedAction
end

module FocusedController
  describe Macros do
    describe ".focused_action" do
      let(:klass) do
        klass = Class.new(FocusedController::Test::MixinTestController)
        klass.name = "PostsController"
        klass.use_focused_macros
        klass.action_parent MyBaseAction
        klass
      end

      subject { klass }

      describe 'create an Action class with a #run method' do
        before do
          subject.focused_action(:show) do
            def run
              "running"
            end
          end
        end

        it 'should have the superclass MyBaseAction' do
          subject::Show.superclass.should == MyBaseAction
        end

        it 'should have a run method' do
          subject::Show.new.run.should == "running"
        end        
      end
    end
  end
end
