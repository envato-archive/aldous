RSpec.describe Aldous::ResultDispatcher::Dsl do
  let(:dsl) {described_class.new(controller_service_class)}

  let(:controller_service_class) {double "controller service class"}

  describe "#execute" do
    subject(:execute) {dsl.execute(controller, mapping)}

    let(:controller) {double "controller", params: params}
    let(:mapping) {double "mapping"}
    let(:params) { Hash.new }

    let(:controller_service) {double "controller service", perform: result}
    let(:result) {double 'result'}

    before do
      allow(controller_service_class).to receive(:new).with(params: params).and_return(controller_service)
      allow(Aldous::ResultDispatcher).to receive(:execute)
    end

    it "performs the controller service" do
      expect(controller_service).to receive(:perform)
      execute
    end

    it "executes the dispatcher with the results of the controller service" do
      expect(Aldous::ResultDispatcher).to receive(:execute).with(controller, result, mapping)
      execute
    end
  end
end
