RSpec.describe Aldous::SimpleDto do
  let(:dto) {described_class.new(data)}
  let(:data) {Hash.new}

  context "errors passed in are available as errors list" do
    let(:data) { {errors: 'hello'} }

    it "can get the right error" do
      expect(dto.errors.first).to eq 'hello'
    end
  end

  context "messages passed in are available as messages list" do
    let(:data) { {messages: 'hello'} }

    it "can get the right message" do
      expect(dto.messages.first).to eq 'hello'
    end
  end

  context "all data passed in is available to get it out again" do
    let(:data) { {hello: 1} }

    it "can get access to the original data" do
      expect(dto._data).to eq data
    end
  end

  context "all keys passed in are available via accessors" do
    let(:data) { {foo: 1, bar: 2} }

    it "can get :foo via method" do
      expect(dto.foo).to eq 1
    end

    it "can get :bar via method" do
      expect(dto.bar).to eq 2
    end
  end
end
