RSpec.describe Aldous::Respondable::Base do
  let(:status) {:foo}
  let(:view_data) {double("view_data")}
  let(:view_context) {double("view context")}

  describe "::new" do
    it "object can be instantiated with the right params" do
      expect{described_class.new(status, view_data, view_context)}.to_not raise_error
    end
  end
end
