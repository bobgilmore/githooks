load "pre_commit/checkers/alert_checker.rb"
require "spec_helper"

RSpec.describe AlertChecker do

  context "code with no alert" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["Hello"]) }

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

  context "code with an alert" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "alert('error')"]) }

    describe "errors?" do
      it "should have an errors" do
        expect(checker.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have one message" do
        expect(checker.messages.count).to eq(1)
      end
    end
  end

  context "code with a flash[:alert]" do
    subject(:checker) { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "flash[:alert] = 'Nooooo!'"]) }

    describe "errors?" do
      it "should not have an error" do
        expect(checker.errors?).to be_falsy
      end
    end

    describe "#messages" do
      it "should have no messages" do
        expect(checker.messages).to be_empty
      end
    end
  end

end
