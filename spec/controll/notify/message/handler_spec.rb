require 'spec_helper'

describe Controll::Notify::Message::Handler do
  subject { Controll::Notify::Message::Handler.new message }

  let(:message)    { Controll::Notify::Message.new text, options  }
  let(:text)       { 'Error while authenticating via {{full_route}}. The service returned invalid data for the user id.' }
  let(:options) do
    {:full_route => 'the_path'}
  end

  describe '.initialize message' do
    its(:message) { should == message } 
  end

  describe '.handle' do
    context 'simple text' do
      let(:text)       { 'simple text' }

      its(:handle) { should == text }
    end

    context 'with arg replacement' do
      its(:handle) { should == 'Error while authenticating via the_path. The service returned invalid data for the user id.' }
    end
  end
end