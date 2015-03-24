load "pre_commit/checkers/private_key_checker.rb"

require 'spec_helper'

RSpec.describe PrivateKeyChecker do

  context "code with private keys" do
    subject { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hello") }

    describe "#errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with an a private key indicator" do
    subject { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "foo; PRIVATE KEY is there!") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with an rsa indicator" do
    subject { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "ssh-rsa follows...") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

end
