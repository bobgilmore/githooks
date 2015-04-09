require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/alert_checker.rb"

RSpec.describe AlertChecker do

  context "code with no alert" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["Hello"]) }
    it_should_behave_like "it finds no error"
  end

  context "code with an alert" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "alert('error')"]) }
    it_should_behave_like "it finds an error"
  end

  context "code with a flash[:alert]" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "flash[:alert] = 'Nooooo!'"]) }
    it_should_behave_like "it finds no error"
  end
end
