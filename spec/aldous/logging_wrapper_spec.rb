RSpec.describe Aldous::LoggingWrapper do
  describe "::log" do
    subject(:log) {described_class.log(error)}
    let(:error) {"hello world"}

    let(:aldous_config) {
      double "aldous_config", error_reporter: error_reporter, logger: logger
    }
    let(:error_reporter) {double "error_reporter", report: nil}
    let(:logger) {double "logger", info: nil}

    before do
      allow(Aldous).to receive(:config).and_return(aldous_config)
    end

    context "when error is a string" do
      let(:error) {"hello world"}

      it "reports the error" do
        expect(error_reporter).to receive(:report).with(error)
        log
      end

      it "logs the error" do
        expect(logger).to receive(:info).with(error)
        log
      end
    end

    context "when error is an error object" do
      let(:error) {RuntimeError.new(message)}
      let(:message) {"hello"}
      let(:backtrace) {"foobar"}

      before do
        error.set_backtrace(backtrace)
      end

      it "reports the error message" do
        expect(error_reporter).to receive(:report).with(error)
        log
      end

      it "logs the error message" do
        expect(logger).to receive(:info).with(message)
        log
      end

      it "logs the error backtrace" do
        expect(logger).to receive(:info).with(backtrace)
        log
      end
    end
  end
end
