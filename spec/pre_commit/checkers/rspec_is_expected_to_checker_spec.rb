require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/rspec_is_expected_to_checker.rb"

RSpec.describe RspecIsExpectedToChecker do

  context "code without any issues" do
    subject(:checker){ RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with a SHOULD" do
    subject(:checker){ RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "foo.should eq 3") }
    it_should_behave_like "it finds no error"
  end

  context "code with an 'is_expected.to'" do
    subject(:checker){ RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "it { is_expected.to eq 3 }") }
    it_should_behave_like "it finds an error"
  end

  context "code with an 'is_expected.to_not'" do
    subject(:checker){ RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "it { is_expected.to_not eq 3 }") }
    it_should_behave_like "it finds an error"
  end
end
