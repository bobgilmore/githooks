load "pre_commit/checkers/strict_paren_spacing_checker.rb"

RSpec.describe StrictParenSpacingChecker do

  context "code with no parens" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
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

  context "code with a properly spaced paren" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: " (Hello) ") }

    describe "errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with a '( '" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi ( there") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with a ' )'" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi (there )") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with a '[ '" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi [ there") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with a ' ]'" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local",
                                            file: "fizzbuzz.rb",
                                            pref_on: true,
                                            changes: "Hi there ]") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with two copies of the same error '( '" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hi ( there\n and here's ( another") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with two different errors '( ' and ' ]'" do
    subject { StrictParenSpacingChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hi ( there\n and here's ]another") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(2) }
    end
  end

end
