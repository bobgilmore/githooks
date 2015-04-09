require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/private_key_checker.rb"

RSpec.describe PrivateKeyChecker do

  context "code with private keys" do
    subject(:checker) { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with an a private key indicator" do
    subject(:checker) { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "foo; PRIVATE KEY is there!") }
    it_should_behave_like "it finds an error"
  end

  context "code with an rsa indicator" do
    subject(:checker) { PrivateKeyChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "ssh-rsa follows...") }
    it_should_behave_like "it finds an error"
  end
end
