describe ActionController::Parents::Methods do
  context 'when extended' do
    subject do
      mod = described_class
      @controller ||= Class.new { extend mod }
    end

    it { should respond_to(:parent_resources) }
  end

  context 'when parent_resources is called' do
    subject do
      mod = described_class
      @controller ||= Class.new do
        extend mod
        parent_resources DummyModel
      end
    end

    it 'includes new ActionController::Parents' do
      expect(subject.ancestors.map(&:class)).to include(ActionController::Parents)
    end

    it 'the Parents module is instantiated with the same arguments of parent_resources' do
      expect(ActionController::Parents).to receive(:new).with(DummyModel).and_call_original
      mod = described_class
      Class.new do
        extend mod
        parent_resources DummyModel
      end
    end
  end
end
