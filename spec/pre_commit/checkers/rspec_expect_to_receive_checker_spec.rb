require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/rspec_expect_to_receive_checker.rb"

RSpec.describe RspecExpectToReceiveChecker do

  context "code without any issues" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with an expect to have_received" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "expect(foo).to have_received") }
    it_should_behave_like "it finds no error"
  end


  context "code with a expect to receive" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "expect(foo).to receive") }
    it_should_behave_like "it finds an error"
  end

  context "code with a expect to receive" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "expect(foo).to_not receive") }
    it_should_behave_like "it finds an error"
  end
end
