RSpec.describe Aldous::Service::ErrorRaising do
  module ErrorRaising
    class BadDummy
      include Aldous::Service::ErrorRaising
    end

    class GoodDummy
      include Aldous::Service::ErrorRaising

      def perform!
        Aldous::Result::Success.new
      end
    end

    class ErrorDummy
      include Aldous::Service::ErrorRaising

      def default_result_options
        {hello: nil}
      end

      def perform!
        raise 'hello'
      end
    end

    class FailingValidator
      def valid?
        false
      end
    end

    class ValidationFailureDummy
      include Aldous::Service::ErrorRaising

      def validator
        FailingValidator.new
      end

      def perform!
        Aldous::Result::Success.new
      end
    end

    class DefaultOptionsDummy
      include Aldous::Service::ErrorRaising

      def default_result_options
        {hello: nil}
      end

      def perform!
        Aldous::Result::Success.new
      end
    end
  end

  it "expects a 'perform!' method to be defined" do
    expect{ErrorRaising::BadDummy.new.perform!}.to raise_error
  end

  it "calls 'perform!' method defined on class" do
    expect(ErrorRaising::GoodDummy.new.perform!).to be_kind_of Aldous::Result::Success
  end

  it "re-raises errors in 'perform!' method defined on class" do
    expect{ ErrorRaising::ErrorDummy.new.perform! }.to raise_error(Aldous::Errors::UserError)
  end

  it "has validation support" do
    expect(ErrorRaising::GoodDummy.new).to be_kind_of Aldous::Service::Validating
  end

  context "default options on every result" do
    it "has default options on a success result" do
      expect{ErrorRaising::DefaultOptionsDummy.new.perform!.hello}.to_not raise_error
    end
  end

  context "validation checks" do
    it "returns a failure result validation fails" do
      expect(ErrorRaising::ValidationFailureDummy.new.perform!).to be_kind_of Aldous::Result::Failure
    end
  end

  context "when errors occur" do
    it "returns a failure result" do
      expect{ErrorRaising::ErrorDummy.new.perform!}.to raise_error(Aldous::Errors::UserError)
    end
  end
end
