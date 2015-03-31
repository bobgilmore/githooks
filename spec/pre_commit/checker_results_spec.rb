load "pre_commit/checker_results.rb"
require "spec_helper"
require "pry"

RSpec.describe CheckerResults do

  subject(:checker) { CheckerResults.new }
  let(:checker_1) { double }
  let(:checker_1_class) { double }
  let(:checker_2) { double }
  let(:checker_2_class) { double }

  before do
    allow(checker_1).to receive(:class).and_return(checker_1_class)
    allow(checker_1_class).to receive(:deactivation_message).and_return("deactivate 1")
    allow(checker_2).to receive(:class).and_return(checker_2_class)
    allow(checker_2_class).to receive(:deactivation_message).and_return("deactivate 2")
  end

  describe "#checkers" do
    context "with no checker" do
      it "returns empty when no checkers are added" do
        expect(checker.checkers).to eq([])
      end
    end

    context "with a checker" do
      before do
        checker.record(checker_1)
        checker.record(checker_2)
      end

      it "returns checkers when checkers were added" do
        expect(checker.checkers).to eq([checker_1, checker_2])
      end
    end
  end

  describe "#errors?" do
    context "with no checker added" do
      it "returns false" do
        expect(checker.errors?).to be_falsey
      end
    end

    context "with an erroring checker" do
      before do
        allow(checker_1).to receive(:errors?).and_return(true)
        checker.record(checker_1)
      end

      it "returns true" do
        expect(checker.errors?).to be_truthy
      end
    end

    context "with a non-erroring checker" do
      before do
        allow(checker_1).to receive(:errors?).and_return(false)
        checker.record(checker_1)
      end

      it "should be falsey" do 
        expect(checker.errors?).to be_falsey
      end
    end

    context "with two checkers, both false" do
      before do
        allow(checker_1).to receive(:errors?).and_return(false)
        allow(checker_2).to receive(:errors?).and_return(false)
        checker.record(checker_1)
        checker.record(checker_2)
      end

      it "should be falsey" do
        expect(checker.errors?).to be_falsey
      end
    end

    context "with two checkers, one false and one true" do
      before do
        allow(checker_1).to receive(:errors?).and_return(false)
        allow(checker_2).to receive(:errors?).and_return(true)
        checker.record(checker_1)
        checker.record(checker_2)
      end

      it "is truthy" do
        expect(checker.errors?).to be_truthy
      end
    end
  end

  describe "#to_s" do
    context "with a checker which returns no errors for this project" do
      before do
        allow(checker_1).to receive(:errors?).and_return(false)
        expect(checker_1).to receive(:errors?)
        expect(checker_1).to_not receive(:messages)
        expect(checker_1_class).to_not receive(:deactivation_message)
        checker.record(checker_1)
      end

      it "should work" do
        expect(checker.to_s).to eq ""
      end
    end

    context "with a checker which returns errors for this project" do
      before do
        allow(checker_1).to receive(:errors?).and_return(true)
        allow(checker_1).to receive(:messages).and_return(['a', 'b'])
        allow(checker_1).to receive(:deactivation_message).and_return(nil)
        expect(checker_1).to receive(:errors?)
        expect(checker_1).to receive(:messages)
        expect(checker_1_class).to receive(:deactivation_message)
        checker.record(checker_1)
      end

      it "includes mention of the git hook" do
        expect(checker.to_s).to include "git pre-commit hook"
      end

      it "includes the error output" do
        expect(checker.to_s).to include "a\nb\n"
      end

      it "includes the deactivation message" do
        expect(checker.to_s).to include "deactivate 1"
      end
    end

    context "with a checker without a deactivation message" do
      before do
        allow(checker_1).to receive(:errors?).and_return(true)
        allow(checker_1).to receive(:messages).and_return(['a', 'b'])
        allow(checker_1).to receive(:deactivation_message).and_return(nil)
        allow(checker_1_class).to receive(:respond_to?).with(:deactivation_message).and_return(false)
        expect(checker_1).to receive(:errors?)
        expect(checker_1).to receive(:messages)
        expect(checker_1_class).to_not receive(:deactivation_message)
        checker.record(checker_1)
      end

      it "includes mention of the git hook" do
        expect(checker.to_s).to include "git pre-commit hook"
      end

      it "includes the error output" do
        expect(checker.to_s).to include "a\nb\n"
      end

      it "doesn't include the deactivation message" do
        expect(checker.to_s).to_not include "deactivate 1"
      end
    end
  end
end
