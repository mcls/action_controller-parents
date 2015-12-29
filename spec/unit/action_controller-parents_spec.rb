require 'spec_helper'

describe ActionController::Parents do
  describe 'when included' do
    let(:controller) { @controller_class.new }

    before(:each) do
      @controller_class = Class.new do
        include ActionController::Parents.new(DummyModel)
        attr_accessor :params
      end
    end

    it "create the #parent_resource method" do
      expect(controller).to respond_to(:parent_resource)
    end

    describe '#parent_resource' do
      it 'deletegates to an instance of Finder' do
        controller.params = { data: 'bla' }
        expect_any_instance_of(described_class::Finder).to receive(:parent_resource).with(controller.params)
        controller.parent_resource
      end

      it 'returns the result' do
        controller.params = { dummy_model_id: 1 }
        expect(controller.parent_resource).to be_a(DummyModel)
      end

      it 'caches the result' do
        controller.params = { dummy_model_id: 1 }
        expect_any_instance_of(described_class::Finder).to receive(:parent_resource).once.with(controller.params).and_call_original
        controller.parent_resource
        controller.parent_resource
      end
    end
  end
end
