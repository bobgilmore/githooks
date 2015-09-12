require "spec_helper"
require "support/shared_examples.rb"

load "pre_commit/checkers/ruby_version_checker.rb"

RSpec.describe RubyVersionChecker do
  context "with .ruby-version" do
    subject(:checker) { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/.ruby-version"], force_pref_on: true) }
    it_should_behave_like "it finds an error"
  end

  context "with .rbenv-version" do
    subject(:checker) { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/.rbenv-version"], force_pref_on: true) }
    it_should_behave_like "it finds an error"
  end

  context "with no version-related files" do
    subject(:checker) { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/biff.css"], force_pref_on: true) }
    it_should_behave_like "it finds no error"
  end
end
