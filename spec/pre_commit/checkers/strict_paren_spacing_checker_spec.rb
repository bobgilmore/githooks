require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/strict_paren_spacing_checker.rb"

RSpec.describe StrictParenSpacingChecker do

  context "code with no parens" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with a properly spaced paren" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: " (Hello) ") }
    it_should_behave_like "it finds no error"
  end

  context "code with a '( '" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi ( there") }
    it_should_behave_like "it finds an error"
  end

  context "code with a ' )'" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi (there )") }
    it_should_behave_like "it finds an error"
  end

  context "code with a '[ '" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi [ there") }
    it_should_behave_like "it finds an error"
  end

  context "code with a ' ]'" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi there ]") }
    it_should_behave_like "it finds an error"
  end

  context "code with two copies of the same error '( '" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            changes: "Hi ( there\n and here's ( another") }
    it_should_behave_like "it finds an error"
  end

  context "code with two different errors '( ' and ' ]'" do
    subject(:checker){ StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            changes: "Hi ( there\n and here's ]another") }
    it_should_behave_like "it finds two errors"
  end

end
