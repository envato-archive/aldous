RSpec.describe Aldous::SendData do
  class Dummy
    include Aldous::SendData

    def data
      'hello'
    end

    def options
      'world'
    end
  end

  subject(:send_data) {Dummy.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  describe "::action" do
    let(:controller) {double("controller")}

    it "returns a send_data response action object" do
      expect(send_data.action(controller)).to be_kind_of Aldous::ResponseAction::SendData
    end

    it 'creates a send_data response action with the relevant parameters' do
      expect(Aldous::ResponseAction::SendData).to receive(:new).with(send_data.data, send_data.options, controller, result)
      send_data.action(controller)
    end
  end
end
