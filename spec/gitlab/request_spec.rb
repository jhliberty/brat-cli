require 'spec_helper'

describe Brat::Request do
  it { should respond_to :get }
  it { should respond_to :post }
  it { should respond_to :put }
  it { should respond_to :delete }

  describe ".default_options" do
    it "should have default values" do
      default_options = Brat::Request.default_options
      expect(default_options).to be_a Hash
      expect(default_options[:parser]).to be_a Proc
      expect(default_options[:format]).to eq(:json)
      expect(default_options[:headers]).to eq({'Accept' => 'application/json'})
      expect(default_options[:default_params]).to be_nil
    end
  end

  describe ".parse" do
    it "should return ObjectifiedHash" do
      body = JSON.unparse({a: 1, b: 2})
      expect(Brat::Request.parse(body)).to be_an Brat::ObjectifiedHash
    end
  end

  describe "#set_request_defaults" do
    context "when endpoint is not set" do
      it "should raise Error::MissingCredentials" do
        expect {
          Brat::Request.new.set_request_defaults(nil, 1234000)
        }.to raise_error(Brat::Error::MissingCredentials, 'Please set an endpoint to API')
      end
    end

    context "when endpoint is set" do
      it "should set base_uri" do
        Brat::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000)
        expect(Brat::Request.base_uri).to eq("http://rabbit-hole.example.org")
      end

      it "should set default_params" do
        Brat::Request.new.set_request_defaults('http://rabbit-hole.example.org', 1234000, 'sudoer')
        expect(Brat::Request.default_params).to eq({:sudo => 'sudoer'})
      end
    end
  end
end
