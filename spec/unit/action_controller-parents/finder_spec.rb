require 'spec_helper'

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
      expect(subject).to eq({ "string_id" => "string", "integer_id" => "integer"})
    end
  end

  describe "works with namespaced class" do
    describe "#parent_resource" do
      subject { described_class.new(Nested::NestedDummyModel).parent_resource(params) }
      let(:params) { { :nested_dummy_model_id => 1 } }

      it 'calls find_by_id! on the found class' do
        expect(Nested::NestedDummyModel).to receive(:find_by_id!).with(1)
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
      subject { described_class.new(Nested::NestedDummyModel).to_resource_class(param_key) }
      let(:param_key) { :nested_dummy_model_id }

      it 'transforms the key to a class' do
        expect(subject).to eq Nested::NestedDummyModel
      end
    end

    describe '#primary_keys' do
      subject { nested_resource.primary_keys }
      let(:parent_resources) { [String, Integer, Nested::NestedDummyModel] }

      it 'sets the keys based on the parent resources' do
        expect(subject).to eq({ "string_id" => "string", "integer_id" => "integer", "nested_dummy_model_id" => "nested/nested_dummy_model" })
      end
    end

  end
end
