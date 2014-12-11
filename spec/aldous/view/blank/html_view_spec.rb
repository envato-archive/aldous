RSpec.describe Aldous::View::Blank::HtmlView do
  subject(:view) {described_class.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  it "includes the Renderable module" do
    expect(described_class.ancestors.include?(Aldous::Renderable)).to be_truthy
  end

  it "implements the 'template' method" do
    expect{ view.template }.to_not raise_error
  end
end
