load "pre_commit/checkers/strict_paren_spacing_checker.rb"
require "spec_helper"

RSpec.describe StrictParenSpacingChecker do

  context "code with no parens" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
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

  context "code with a properly spaced paren" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: " (Hello) ") }

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

  context "code with a '( '" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi ( there") }

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

  context "code with a ' )'" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi (there )") }

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

  context "code with a '[ '" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi [ there") }

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

  context "code with a ' ]'" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi there ]") }

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

  context "code with two copies of the same error '( '" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hi ( there\n and here's ( another") }

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

  context "code with two different errors '( ' and ' ]'" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hi ( there\n and here's ]another") }

    describe "errors?" do
      it "should have an error" do
        expect(subject.errors?).to be_truthy
      end
    end

    describe "#messages" do
      it "should have two messages" do
        expect(subject.messages.count).to eq(2)
      end
    end
  end

end
