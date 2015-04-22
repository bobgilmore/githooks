require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/alert_checker.rb"

RSpec.describe AlertChecker do
  let(:checker_class) { AlertChecker }
  context "code with no alert" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["Hello"]) }
    it_should_behave_like "it finds no error"
  end

  context "code with an alert" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "alert('error')"]) }
    it_should_behave_like "it finds an error"

    context "in an Objective-C file" do
      subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.m", changes: ["x=3", "alert('error')"]) }
      it_should_behave_like "it finds no error"
    end

    context "in a Swift file" do
      subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.swift", changes: ["x=3", "alert('error')"]) }
      it_should_behave_like "it finds no error"
    end
  end

  context "code with a flash[:alert]" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "flash[:alert] = 'Nooooo!'"]) }
    it_should_behave_like "it finds no error"
  end
end
