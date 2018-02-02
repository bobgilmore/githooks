require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/swift_explicit_init_checker.rb"

RSpec.describe SwiftExplicitInitChecker do
  let(:checker_class) { SwiftExplicitInitChecker }

  context "code without any issues" do
    subject(:checker) { test_class_with_change_with_extension(checker_class, "Hello", "swift") }
    it_should_behave_like "it finds no error"
  end

  context "code defining in init" do
    subject(:checker) { test_class_with_change_with_extension(checker_class, " init(a)", "swift") }
    it_should_behave_like "it finds no error"
  end

  context "code with an explicit init call" do
    subject(:checker) { test_class_with_change_with_extension(checker_class, "FizzBuzz.init(a)", "swift") }
    it_should_behave_like "it finds an error"
  end

end
