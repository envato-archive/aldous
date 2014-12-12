RSpec.describe Aldous::Dispatch::Request::DefaultResponseTypes::Mapping do
  class Aldous::Dispatch::Request::DefaultResponseTypes::Mapping::Dummy
    include Aldous::Dispatch::Request::DefaultResponseTypes::Mapping

    def default_view
      'hello'
    end

    def configured_default_response_types
      {}
    end
  end

  class Aldous::Dispatch::Request::DefaultResponseTypes::Mapping::AnotherDummy
    include Aldous::Dispatch::Request::DefaultResponseTypes::Mapping

    def configured_default_response_types
      {Aldous::Result::Unauthenticated   => 'foobar'}
    end
  end

  let(:dummy_response_types) {Aldous::Dispatch::Request::DefaultResponseTypes::Mapping::Dummy.new}
  let(:another_dummy_response_types) {Aldous::Dispatch::Request::DefaultResponseTypes::Mapping::AnotherDummy.new}

  describe "#configured_default_response_types" do
    it "should be a blank" do
      expect(dummy_response_types.configured_default_response_types).to eq Hash.new
    end
  end

  describe "#default_view" do
    it "returns the overridden value" do
      expect(dummy_response_types.default_view).to eq 'hello'
    end
  end

  describe "#default_response_types" do
    it "it returns a hash with overriden values" do
      expect(dummy_response_types.default_response_types).to eq Hash.new.merge({
        ::Aldous::Result::Unauthenticated   => 'hello',
        ::Aldous::Result::Unauthorized      => 'hello',
        ::Aldous::Result::NotFound          => 'hello',
        ::Aldous::Result::ServerError       => 'hello',
      })
    end
  end

  describe "#response_type_for" do
    context "when configured default response types are empty" do
      it "returns the mapped response type" do
        expect(dummy_response_types.response_type_for(::Aldous::Result::Unauthenticated)).to eq 'hello'
      end
    end

    context "when configured default response types are not empty" do
      it "returns the configured mapped response type" do
        expect(another_dummy_response_types.response_type_for(::Aldous::Result::Unauthenticated)).to eq 'foobar'
      end
    end
  end
end
