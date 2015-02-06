RSpec.describe Aldous::View::Blank::TextView do
  subject(:view) {described_class.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  it "inherits from Renderable" do
    expect(described_class.ancestors.include?(Aldous::Respondable::Renderable)).to be_truthy
  end

  it "implements the 'template' method" do
    expect{ view.template }.to_not raise_error
  end

  describe '#template' do
    subject(:template) { view.template }

    it 'returns blank text template' do
      expect(template).to eq(text: "")
    end
  end
end
