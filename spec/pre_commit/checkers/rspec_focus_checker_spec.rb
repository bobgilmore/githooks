require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/rspec_focus_checker.rb"

RSpec.describe RspecFocusChecker do
  let(:checker_class) { RspecFocusChecker }

  context "code without any issues" do
    subject(:checker) { test_class_with_change(checker_class, "Hello") }
    it_should_behave_like "it finds no error"
  end

  context "code with no metatags in a describe block" do
    subject(:checker) do
      test_class_with_change(
        checker_class, "describe \"something\" do"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with a 'focus' in a let statement" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "let(:focus) { 'focus' }"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with a 'focus' in an expect statement" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "expect(focus).to be true"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with single quotes and non-focus metadata keys" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', bar: true do"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with double quotes and non-focus metadata keys" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", bar: true do"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with single quotes and symbol non-focus metadata keys" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :bar do"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with double quotes and symbol non-focus metadata keys" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :bar do"
      )
    end
    it_should_behave_like "it finds no error"
  end

  context "code with double quotes and single focus symbol metadata key" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :focus do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and single focus symbol metadata key" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :focus do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other symbol metadata keys after focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :focus, :foo do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other symbol metadata keys after focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :focus, :foo do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other symbol metadata keys before focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :foo, :focus do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other symbol metadata keys before focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :foo, :focus do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other symbol metadata keys either side of focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :foo, :focus, :bar do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other symbol metadata keys either side of focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :foo, :focus, :bar do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and single focus metadata key" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", focus: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and single focus hashrocket metadata key" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :focus => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and single focus metadata key" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', focus: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and single focus hashrocket metadata key" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :focus => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other metadata keys after focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", focus: true, foo: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other hashrocket metadata keys after focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :focus => true, :foo => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other metadata keys after focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', focus: true, foo: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other hashrocket metadata keys after focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :focus => true, :foo => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other metadata keys before focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", foo: true, focus: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other hashrocket metadata keys before focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :foo => true, :focus => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other metadata keys before focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', foo: true, focus: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other hashrocket metadata keys before focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :foo => true, :focus => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other metadata keys either side of focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", foo: true, focus: true, bar: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with double quotes and other hashrocket metadata keys either side of focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe \"foo\", :foo => true, :focus => true, :bar => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other metadata keys either side of focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', foo: true, focus: true, bar: true do"
      )
    end
    it_should_behave_like "it finds an error"
  end

  context "code with single quotes and other hashrocket metadata keys either side of focus" do
    subject(:checker) do
      test_class_with_change(
        checker_class,
        "describe 'foo', :foo => true, :focus => true, :bar => true do"
      )
    end
    it_should_behave_like "it finds an error"
  end
end
