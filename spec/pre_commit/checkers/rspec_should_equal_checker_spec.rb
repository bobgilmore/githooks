load "pre_commit/checkers/rspec_should_equal_checker.rb"
require "spec_helper"

RSpec.describe RspecShouldEqualChecker do

  context "code without any issues" do
    subject(:checker){ RspecShouldEqualChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hello") }

    describe "#errors?" do
      it "should have no errors" do
        expect(checker.errors?).to be_falsey
      end
    end

    describe "#messages" do
      it "should have no messages" do
        expect(checker.messages).to be_empty
      end
    end
  end

  context "code without any issues" do
    subject(:checker){ RspecShouldEqualChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "should eq") }

    describe "#errors?" do
      it "should have no errors" do
        expect(checker.errors?).to be_falsey
      end
    end

    describe "#messages" do
      it "should have no messages" do
        expect(checker.messages).to be_empty
      end
    end
  end

  context "code with a 'should =='" do
    subject(:checker){ RspecShouldEqualChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "  foo.should  == 3") }

    describe "errors?" do
      it "should have an error" do
        expect(checker.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(checker.messages.count).to eq(1)
      end
    end
  end

  context "code with a 'should_not =='" do
    subject(:checker){ RspecShouldEqualChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "  foo.should_not  == 3") }

    describe "errors?" do
      it "should have an error" do
        expect(checker.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(checker.messages.count).to eq(1)
      end
    end
  end

  context "code with an 'should !='" do
    subject(:checker){ RspecShouldEqualChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "  foo.should  != 3") }

    describe "errors?" do
      it "should have an error" do
        expect(checker.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(checker.messages.count).to eq(1)
      end
    end
  end

end
