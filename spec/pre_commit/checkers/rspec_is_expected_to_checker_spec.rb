load "pre_commit/checkers/rspec_is_expected_to_checker.rb"

RSpec.describe RspecIsExpectedToChecker do

  context "code without any issues" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hello") }

    describe "#errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with a SHOULD" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "foo.should eq 3") }

    describe "errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with an 'is_expected.to'" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "it { is_expected.to eq 3 }") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with an 'is_expected.to_not'" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "it { is_expected.to_not eq 3 }") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

end
