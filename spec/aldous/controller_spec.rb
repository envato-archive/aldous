RSpec.describe Aldous::Controller do
  before do
    class ExampleController
      include Aldous::Controller
    end
  end

  describe "::controller_actions" do
    before do
      ExampleController.controller_actions(:hello, :world)
    end

    context "a controller instance" do
      let(:controller) {ExampleController.new}

      it "responds to :hello" do
        expect(controller).to respond_to :hello
      end

      it "responds to :world" do
        expect(controller).to respond_to :world
      end
    end
  end
end
