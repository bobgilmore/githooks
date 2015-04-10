require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/forbidden_string_checker.rb"

RSpec.describe ForbiddenStringChecker do
  let(:checker_class) { ForbiddenStringChecker }

  context "code that's OK" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with tmp_debugging markers" do
    subject(:checker) { test_class_with_change(checker_class, "Hello TMP_DEBUG there") }
    it_should_behave_like "it finds an error"
  end

  context "code with git conflict markers >>>>>>" do
    subject(:checker) { test_class_with_change(checker_class, "Hello >>>>>>>> there") }
    it_should_behave_like "it finds an error"
  end

  context "code with git conflict markers <<<<<<<" do
    subject(:checker) { test_class_with_change(checker_class, "Hello <<<<<<<< there") }
    it_should_behave_like "it finds an error"
  end

  context "code with git conflict markers =======" do
    subject(:checker) { test_class_with_change(checker_class, "Hello ======== there") }
    it_should_behave_like "it finds an error"
  end

  context "code that calls the pry debugger" do
    subject(:checker) { test_class_with_change(checker_class, "Hello binding.pry there") }
    it_should_behave_like "it finds an error"
  end

  context "code that calls the pry remote debugger" do
    subject(:checker) { test_class_with_change(checker_class, "Hello binding.remote_pry there") }
    it_should_behave_like "it finds an error"
  end

  context "code with Ruby < 2.0 or JS debug code" do
    subject(:checker) { test_class_with_change(checker_class, "Hello debugger there") }
    it_should_behave_like "it finds an error"
  end

  context "code with Ruby >= 2.0 debug code" do
    subject(:checker) { test_class_with_change(checker_class, "Hello byebug there") }
    it_should_behave_like "it finds an error"
  end

  context "code with explicit calls to logger.debug markers" do
    subject(:checker) { test_class_with_change(checker_class, "Hello logger.debug there") }
    it_should_behave_like "it finds an error"
  end

  context "code with Capybara debug code" do
    subject(:checker) { test_class_with_change(checker_class, "Hello save_and_open_screenshot there") }
    it_should_behave_like "it finds an error"
  end

  context "code with Capybara debug code" do
    subject(:checker) { test_class_with_change(checker_class, "Hello save_screenshot there") }
    it_should_behave_like "it finds an error"
  end

  context "code with Capybara debug code" do
    subject(:checker) { test_class_with_change(checker_class, "Hello save_and_open_page there") }
    it_should_behave_like "it finds an error"
  end

  context "in a node project" do

    context "code with nothing wrong" do
      subject(:checker) { test_class_with_change(checker_class, "Hello", project_type: :node) }
      it_should_behave_like "it finds no error"
    end

    context "code with JS debug code" do
      subject(:checker) { test_class_with_change(checker_class, "Hello debugger there", project_type: :node) }
      it_should_behave_like "it finds an error"
    end

    context "code with a Node-specific problem" do
      subject(:checker) { test_class_with_change(checker_class, "Hello console.print there", project_type: :node) }
      it_should_behave_like "it finds an error"
    end
  end
end
