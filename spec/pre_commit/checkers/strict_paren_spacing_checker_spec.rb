require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/strict_paren_spacing_checker.rb"

RSpec.describe StrictParenSpacingChecker do
  let(:checker_class) { StrictParenSpacingChecker }

  context "code with no parens" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with a properly spaced paren" do
    subject(:checker) { test_class_with_change(checker_class, " (Hello) ") }
    it_should_behave_like "it finds no error"
  end

  context "code with a '( '" do
    let(:code) { "Hi ( there" }

    subject(:checker) { test_class_with_change(checker_class, code) }
    it_should_behave_like "it finds an error"

    context "in a shell script" do
      subject(:checker) { test_class_with_change(checker_class, code, file: "foo.sh") }
      it_should_behave_like "it finds no error"
    end

    context "in an extensionless shell script" do
      subject(:checker) { test_class_with_change(checker_class, code, file: "foo") }
      it_should_behave_like "it finds no error"
    end

    context "in a bash script" do
      subject(:checker) { test_class_with_change(checker_class, code, file: "foo.bash") }
      it_should_behave_like "it finds no error"
    end
  end

  context "code with a ' )'" do
    let(:code) { "Hi (there )" }

    subject(:checker) { test_class_with_change(checker_class, code) }
    it_should_behave_like "it finds an error"

    context "in a shell script" do
      subject(:checker) { test_class_with_change(checker_class, code, file: "foo.sh") }
      it_should_behave_like "it finds no error"
    end

    context "in an extensionless shell script" do
      subject(:checker) { test_class_with_change(checker_class, code, file: "foo") }
      it_should_behave_like "it finds no error"
    end

    context "in a bash script" do
      subject(:checker) { test_class_with_change(checker_class, code, file: "foo.bash") }
      it_should_behave_like "it finds no error"
    end
  end

  context "code with a '[ '" do
    let(:code) { "Hi [ there" }

    subject(:checker) { test_class_with_change(checker_class, code) }
    it_should_behave_like "it finds an error"
  end

  context "code with a ' ]'" do
    let(:code) { "Hi there ]" }

    subject(:checker) { test_class_with_change(checker_class, code) }
    it_should_behave_like "it finds an error"
  end

  context "code with two copies of the same error '( '" do
    subject(:checker) { test_class_with_change(checker_class, "Hi ( there\n and here's ( another") }
    it_should_behave_like "it finds an error"
  end

  context "code with two different errors '( ' and ' ]'" do
    subject(:checker) { test_class_with_change(checker_class, "Hi ( there\n and here's ]another") }
    it_should_behave_like "it finds two errors"
  end

end
