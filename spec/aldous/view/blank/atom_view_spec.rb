RSpec.describe Aldous::View::Blank::AtomView do
  subject(:view) {described_class.new(status, view_data, view_context)}

  let(:status) {nil}
  let(:view_data) {double("result")}
  let(:view_context) {double("view context")}

  it "inherits from Renderable" do
    expect(described_class.ancestors.include?(Aldous::Respondable::Renderable)).to be_truthy
  end

  it "implements the 'template' method" do
    expect{ view.template }.to_not raise_error
  end
end
