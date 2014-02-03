require 'spec_helper'

class DummyController
  attr_accessor :params
  def params
    @params || {}
  end
end

class DummyModel
  def self.find_by_id!(id)
    DummyModel.new
  end
end

describe ActionController::Parents do
  describe 'when included' do
    let(:dummy) { DummyController.new }

    before(:each) do
      class DummyController; include(ActionController::Parents.new); end
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

describe ActionController::Parents::Finder do
  let(:nested_resource) { described_class.new(parent_resources) }
  let(:parent_resources) { [] }

  describe '#parent_resource' do
    subject { described_class.new(DummyModel).parent_resource(params) }
    let(:params) { { :dummy_model_id => 1 } }

    it 'calls find_by_id! on the found class' do
      expect(DummyModel).to receive(:find_by_id!).with(1)
      subject
    end

    context 'when class not found' do
      let(:params) { { :random_model_id => 1 } }
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#to_resource_class' do
    subject { described_class.new(DummyModel).to_resource_class(param_key) }
    let(:param_key) { :dummy_model_id }

    it 'transforms the key to a class' do
      expect(subject).to eq DummyModel
    end
  end

  describe '#primary_keys' do
    subject { nested_resource.primary_keys }
    let(:parent_resources) { [String, Integer] }

    it 'sets the keys based on the parent resources' do
      expect(subject).to eq %w(string_id integer_id)
    end
  end

end
