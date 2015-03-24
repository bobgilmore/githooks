load "pre_commit/checkers/ruby_version_checker.rb"

RSpec.describe RubyVersionChecker do

  context "with .ruby-version" do
    subject { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/.ruby-version"], pref_on: true)}

    describe "#errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq 1 }
    end
  end

  context "with .rbenv-version" do
    subject { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/.rbenv-version"], pref_on: true) }

    describe "#errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq 1 }
    end
  end

  context "with no version-related files" do
    subject { RubyVersionChecker.new(files: ["foo/bar.rb", "foo/biff.css"], pref_on: true) }

    describe "#errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

end
