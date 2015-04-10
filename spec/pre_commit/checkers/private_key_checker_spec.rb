require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/private_key_checker.rb"

RSpec.describe PrivateKeyChecker do
  let(:checker_class) { PrivateKeyChecker }

  context "code with private keys" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with an a private key indicator" do
    subject(:checker) { test_class_with_change(checker_class, "foo; PRIVATE KEY is there!") }
    it_should_behave_like "it finds an error"
  end

  context "code with an rsa indicator" do
    subject(:checker) { test_class_with_change(checker_class, "ssh-rsa follows...") }
    it_should_behave_like "it finds an error"
  end
end
