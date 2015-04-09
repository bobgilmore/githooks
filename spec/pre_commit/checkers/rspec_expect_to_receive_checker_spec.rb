load "pre_commit/checkers/rspec_expect_to_receive_checker.rb"
require "spec_helper"

RSpec.describe RspecExpectToReceiveChecker do

  context "code without any issues" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
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

  context "code with an expect to have_received" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "expect(foo).to have_received") }

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


  context "code with a expect to receive" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "expect(foo).to receive") }

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

  context "code with a expect to receive" do
    subject(:checker){ RspecExpectToReceiveChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "expect(foo).to_not receive") }

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
