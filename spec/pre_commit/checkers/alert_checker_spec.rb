load "pre_commit/checkers/alert_checker.rb"

require 'spec_helper'

RSpec.describe AlertChecker do

  context "code with no alert" do
    subject { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["Hello"]) }

    describe "#errors?" do
      its(:errors?) { should be_falsey }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

  context "code with an alert" do
    subject { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "alert('error')"]) }

    describe "errors?" do
      its(:errors?) { should be_truthy }
    end

    describe "#messages" do
      its("messages.count") { should eq(1) }
    end
  end

  context "code with a flash[:alert]" do
    subject { AlertChecker.new(directory: "/usr/local", file: "fizzbuzz.rb", changes: ["x=3", "flash[:alert] = 'Nooooo!'"]) }

    describe "errors?" do
      its(:errors?) { should be_falsy }
    end

    describe "#messages" do
      its(:messages) { should be_empty }
    end
  end

end
