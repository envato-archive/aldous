RSpec.describe Aldous::Respondable::Shared::Flash do
  let(:flash) {described_class.new(result, flash_container)}

  let(:controller) {double 'controller', flash: flash_container}
  let(:result) {double 'result', errors: errors}
  let(:errors) {['1', '2']}
  let(:flash_container) {double 'flash container', now: flash_now}
  let(:flash_now) { {} }

  describe "#set_error" do
    context "when errors exist" do
      let(:flash_container) { {} }

      it "sets the error on the flash container" do
        flash.set_error
        expect(flash_container[:error]).to eq '1'
      end
    end

    context "when errors don't exist" do
      let(:errors) {[]}
      let(:flash_container) { {} }

      it "doesn't set the error on the flash container" do
        flash.set_error
        expect(flash_container[:error]).to eq nil
      end
    end
  end
end
