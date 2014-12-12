RSpec.describe Aldous::Dispatch::Request::DefaultResponseTypes::Json do
  let(:response_types) {described_class.new}

  describe "#default_view" do
    it "returns the blank json view" do
      expect(response_types.default_view).to eq Aldous::View::Blank::JsonView
    end
  end

  describe "#configured_default_response_types" do
    it "returns the default json response types from config" do
      expect(Aldous.config).to receive(:default_json_response_types)
      response_types.configured_default_response_types
    end
  end
end

#module Aldous
  #module Dispatch
    #module Request
      #module DefaultResponseTypes
        #class Json
          #include Mapping

          #def default_view
            #::Aldous::View::Blank::JsonView
          #end

          #def configured_default_response_types
            #::Aldous.config.default_json_response_types
          #end
        #end
      #end
    #end
  #end
#end

