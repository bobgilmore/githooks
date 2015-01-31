load "pre_commit/checkers/user_home_checker.rb"

RSpec.describe UserHomeChecker do

  context "code with nothing suspicious" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "Hello", user: 'bob') }

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

  context "code with a home/ but not for that user" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /home/fred", user: "bob") }

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
  
  context "code with a /home/(user)" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /home/bob/.emacs.d", user: "bob") }
    
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
  
  context "code with a /Users/(user)" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /Users/bob", user: "bob") }
      
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
  

  context "code with a /export/home/(user)" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "cd /export/home/bob", user: "bob") }

    describe "errors?" do
      it "should have an error" do
        expect(subject.errors?).to be_truthy
      end
    end
    
    describe "#messages" do
      it "should have one message" do
        expect(subject.messages.count).to eq(2)
      end
    end
  end
  
  context "code with two copies of the same error" do
    subject { UserHomeChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: "/home/bob there\n and here's /Users/bob", user: "bob") }
    
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
