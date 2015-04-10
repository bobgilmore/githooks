require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/rspec_is_expected_to_checker.rb"

RSpec.describe RspecIsExpectedToChecker do
  let(:checker_class) { RspecIsExpectedToChecker }

  context "code without any issues" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with a SHOULD" do
    subject(:checker) { test_class_with_change(checker_class, "foo.should eq 3") }
    it_should_behave_like "it finds no error"
  end

  context "code with an 'is_expected.to'" do
    subject(:checker) { test_class_with_change(checker_class, "it { is_expected.to eq 3 }") }
    it_should_behave_like "it finds an error"
  end

  context "code with an 'is_expected.to_not'" do
    subject(:checker) { test_class_with_change(checker_class, "it { is_expected.to_not eq 3 }") }
    it_should_behave_like "it finds an error"
  end
end
