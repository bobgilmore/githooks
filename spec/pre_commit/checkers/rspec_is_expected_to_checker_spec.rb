load "pre_commit/checkers/rspec_is_expected_to_checker.rb"

RSpec.describe RspecIsExpectedToChecker do

  context "code without any issues" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hello") }

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

  context "code with a SHOULD" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "foo.should eq 3") }

    describe "errors?" do
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

  context "code with an 'is_expected.to'" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "it { is_expected.to eq 3 }") }

    describe "errors?" do
      it "should have an error" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(subject.messages.count).to eq(1)
      end
    end
  end

  context "code with an 'is_expected.to_not'" do
    subject { RspecIsExpectedToChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "it { is_expected.to_not eq 3 }") }

    describe "errors?" do
      it "should have an error" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(subject.messages.count).to eq(1)
      end
    end
  end

end
