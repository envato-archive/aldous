RSpec.describe Aldous::ControllerService::ParamPresentPrecondition do
  subject(:precondition) { described_class.new(params, param_key) }
  let(:params) { double 'params', require: true }
  let(:param_key) { 'hello' }

  describe '#check' do
    subject(:check) { precondition.check }

    context "when params responds to require" do
      it 'executes require' do
        expect(params).to receive(:require).with(param_key.to_sym)
        check
      end

      context 'precondition passes' do
        it 'returns Success result' do
          expect(check).to be_a Aldous::Result::Success
          check
        end
      end

      context 'precondition fails' do
        let(:e) { RuntimeError.new('item missing') }

        before do
          allow(params).to receive(:require).and_raise e
        end

        it 'returns Failure result' do
          expect(check).to be_a Aldous::Result::Failure
          check
        end
      end
    end

    context "when params does not respond to require" do
      let(:params) { {hello: 'world'} }

      context 'precondition passes' do
        it 'returns Success result' do
          expect(check).to be_a Aldous::Result::Success
          check
        end
      end

      context 'precondition fails' do
        let(:params) { Hash.new }

        it 'returns Failure result' do
          expect(check).to be_a Aldous::Result::Failure
          check
        end
      end
    end
  end
end
