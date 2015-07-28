require 'spec_helper'

describe ActionController::Parents::Finder do
  let(:finder) { described_class.new(parent_resources) }
  let(:parent_resources) { [] }

  it "doesn't allow classes which don't respond to :find method" do
    expect {
      described_class.new(String)
    }.to raise_error(
      ActionController::Parents::NoFindMethodError,
      "Parent resource String doesn't respond to :find",
    )
  end

  describe '#parent_resource' do
    subject { described_class.new(DummyModel).parent_resource(params) }
    let(:params) { { :dummy_model_id => 1 } }

    it 'calls :find method on the found class' do
      expect(DummyModel).to receive(:find).with(1)
      subject
    end

    context 'when class not found' do
      let(:params) { { :random_model_id => 1 } }
      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#primary_keys' do
    subject { finder.primary_keys }
    let(:parent_resources) { [DummyModel] }

    it 'sets the keys based on the parent resources' do
      expect(subject).to eq({ "dummy_model_id" => DummyModel })
    end
  end

  describe "works with namespaced class" do
    describe "#parent_resource" do
      subject { described_class.new(Nested::NestedDummyModel).parent_resource(params) }
      let(:params) { { :nested_dummy_model_id => 1 } }

      it 'calls :find method on the found class' do
        expect(Nested::NestedDummyModel).to receive(:find).with(1)
        subject
      end

      context 'when class not found' do
        let(:params) { { :random_model_id => 1 } }
        it 'returns nil' do
          expect(subject).to be_nil
        end
      end
    end

    describe '#primary_keys' do
      subject { finder.primary_keys }
      let(:parent_resources) { [DummyModel, Nested::NestedDummyModel] }

      it 'sets the keys based on the parent resources' do
        expect(subject).to eq({ "dummy_model_id" => DummyModel, "nested_dummy_model_id" => Nested::NestedDummyModel })
      end
    end

  end
end
