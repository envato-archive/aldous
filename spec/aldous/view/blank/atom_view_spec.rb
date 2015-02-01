RSpec.describe Aldous::View::Blank::AtomView do
  subject(:view) {described_class.new(result, view_context)}

  let(:result) {double("result")}
  let(:view_context) {double("view context")}

  it "inherits from Renderable" do
    expect(described_class.ancestors.include?(Aldous::Respondable::Renderable)).to be_truthy
  end

  it "implements the 'template' method" do
    expect{ view.template }.to_not raise_error
  end
end

#require 'aldous/renderable'

#module Aldous
  #module View
    #module Blank
      #class AtomView
        #include Renderable

        #def template
        #end
      #end
    #end
  #end
#end
