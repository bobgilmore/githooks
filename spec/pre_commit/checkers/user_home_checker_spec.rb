load "pre_commit/checkers/user_home_checker.rb"

RSpec.describe UserHomeChecker do

  context "code with nothing suspicious" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hello", user: 'bob') }

    describe "#errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with a home/ but not for that user" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /home/fred", user: "bob") }

    describe "errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with a /home/(user)" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /home/bob/.emacs.d", user: "bob") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with a /Users/(user)" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /Users/bob", user: "bob") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end


  context "code with a /export/home/(user)" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /export/home/bob", user: "bob") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(2) }
    end
  end

  context "code with two copies of the same error" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "/home/bob there\n and here's /Users/bob", user: "bob") }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(2) }
    end
  end

end
