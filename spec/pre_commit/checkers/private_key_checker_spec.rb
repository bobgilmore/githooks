load "pre_commit/checkers/private_key_checker.rb"

require 'spec_helper'

RSpec.describe PrivateKeyChecker do

  context "code with private keys" do
    subject { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hello") }

    describe "#errors?" do
      it "should have no errors" do
        expect(subject.errors?).to be_falsey
      end
    end

    describe "#messages" do
      it "should have no messages" do
        expect(subject.messages).to be_empty
      end
    end
  end

  context "code with an a private key indicator" do
    subject { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "foo; PRIVATE KEY is there!") }

    describe "errors?" do
      it "should have an errors" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(subject.messages.count).to eq(1)
      end
    end
  end

  context "code with an rsa indicator" do
    subject { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "ssh-rsa follows...") }

    describe "errors?" do
      it "should have an errors" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(subject.messages.count).to eq(1)
      end
    end
  end

end
