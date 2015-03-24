load "pre_commit/checkers/ruby_version_checker.rb"
require "spec_helper"

RSpec.describe RubyVersionChecker do

  context "with .ruby-version" do
    subject { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/.ruby-version"], pref_on: true)}
    
    describe "#errors?" do
      it "should have an error" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have a messages" do
        expect(subject.messages.count).to eq 1
      end
    end
  end

  context "with .rbenv-version" do
    subject { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/.rbenv-version"], pref_on: true) }
    
    describe "#errors?" do
      it "should have an error" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have a messages" do
        expect(subject.messages.count).to eq 1
      end
    end
  end

  context "with no version-related files" do
    subject { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/biff.css"], pref_on: true) }
    
    describe "#errors?" do
      it "should have no errors" do
        expect(subject.errors?).to be_falsey
      end
    end

    describe "#messages" do
      it "should have no messages" do
        expect(subject.messages).to be_empty
      end
    end
  end

end
