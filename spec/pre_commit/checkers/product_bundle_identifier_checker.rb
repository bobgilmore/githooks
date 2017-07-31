require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/product_bundle_identifier_checker.rb"

RSpec.describe DevelopmentTeamChecker do
  let(:checker_class) { DevelopmentTeamChecker }

  context "code with no bundle change" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end


  context "code with a bundle change" do
    subject(:checker) { test_class_with_change(checker_class, "PRODUCT_BUNDLE_IDENTIFIER = ABCD") }
    it_should_behave_like "it finds an error"
  end
end
