require 'spec_helper'

describe ActionController::Parents do
  describe 'when included' do
    let(:dummy) { @controller_class.new }

    before(:each) do
      @controller_class = Class.new do
        include ActionController::Parents.new
      end
    end

    it "create the #parent_resource" do
      expect(dummy).to respond_to(:parent_resource)
    end

    describe '#parent_resource' do
      it 'deletegates to an instance of Finder' do
        args = []
        allow(dummy).to receive(:params) { args }
        expect_any_instance_of(described_class::Finder).to receive(:parent_resource).with(args)
        dummy.parent_resource
      end
    end
  end
end
