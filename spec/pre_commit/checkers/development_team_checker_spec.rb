require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/development_team_checker.rb"

RSpec.describe DevelopmentTeamChecker do
  let(:checker_class) { DevelopmentTeamChecker }

  context "code with no team change" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with a lowercase team change" do
    subject(:checker) { test_class_with_change(checker_class, "DevelopmentTeam = ABCD") }
    it_should_behave_like "it finds an error"
  end

  context "code with an uppercase team change" do
    subject(:checker) { test_class_with_change(checker_class, "DEVELOPMENT_TEAM = ABCD") }
    it_should_behave_like "it finds an error"
  end
end
