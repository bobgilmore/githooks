require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/rspec_to_not_checker.rb"

RSpec.describe RspecToNotChecker do
  let(:checker_class) { RspecToNotChecker }

  context "code without any issues" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code without any issues" do
    subject(:checker) { test_class_with_change(checker_class, "expect(foo).not_to eq 1") }
    it_should_behave_like "it finds no error"
  end

  context "code with a 'to_not'" do
    subject(:checker) { test_class_with_change(checker_class, "expect(foo).to_not eq 1") }
    it_should_behave_like "it finds an error"
  end
end
