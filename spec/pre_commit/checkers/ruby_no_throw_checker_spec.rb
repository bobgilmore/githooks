require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/ruby_no_throw_checker.rb"

RSpec.describe RubyNoThrowChecker do
  let(:checker_class) { RubyNoThrowChecker }

  context "code without any issues" do
    subject(:checker) { test_class_with_change(checker_class, "catch error") }
    it_should_behave_like "it finds no error"
  end

  context "code with a 'throw'" do
    subject(:checker) { test_class_with_change(checker_class, "throw error") }
    it_should_behave_like "it finds an error"
  end
end
