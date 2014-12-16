RSpec.describe Aldous::Service::ErrorFree do
  module ErrorFree
    class BadDummy
      include Aldous::Service::ErrorFree
    end

    class GoodDummy
      include Aldous::Service::ErrorFree

      def perform
        Aldous::Result::Success.new
      end
    end

    class ErrorDummy
      include Aldous::Service::ErrorFree

      def default_result_options
        {hello: nil}
      end

      def perform
        raise 'hello'
      end
    end

    class FailingValidator
      def valid?
        false
      end
    end

    class ValidationFailureDummy
      include Aldous::Service::ErrorFree

      def validator
        FailingValidator.new
      end

      def perform
        Aldous::Result::Success.new
      end
    end

    class DefaultOptionsDummy
      include Aldous::Service::ErrorFree

      def default_result_options
        {hello: nil}
      end

      def perform
        Aldous::Result::Success.new
      end
    end
  end

  it "expects a 'perform' method to be defined" do
    expect{ErrorFree::BadDummy.new.perform}.to raise_error
  end

  it "calls 'perform' method defined on class" do
    expect(ErrorFree::GoodDummy.new.perform).to be_kind_of Aldous::Result::Success
  end

  it "rescues errors in 'perform' method defined on class" do
    expect(ErrorFree::ErrorDummy.new.perform).to be_kind_of Aldous::Result::Failure
  end

  it "has validation support" do
    expect(ErrorFree::GoodDummy.new).to be_kind_of Aldous::Service::Validating
  end

  context "default options on every result" do
    it "has default options on a success result" do
      expect{ErrorFree::DefaultOptionsDummy.new.perform.hello}.to_not raise_error
    end

    it "has default options on an error result" do
      expect{ErrorFree::ErrorDummy.new.perform.hello}.to_not raise_error
    end
  end

  context "validation checks" do
    let(:service) {ErrorFree::GoodDummy.new}

    it "returns a failure result validation fails" do
      expect(ErrorFree::ValidationFailureDummy.new.perform).to be_kind_of Aldous::Result::Failure
    end
  end

  context "when errors occur" do
    it "reports to the error reporter" do
      expect(Aldous::DummyErrorReporter).to receive(:report).with(instance_of(RuntimeError))
      ErrorFree::ErrorDummy.new.perform
    end

    it "returns a failure result" do
      expect(ErrorFree::ErrorDummy.new.perform).to be_kind_of Aldous::Result::Failure
    end
  end
end
