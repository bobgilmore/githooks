load "checker_results.rb"

RSpec.describe CheckerResults do

 # let(:checker_1) { double }
 # let(:checker_1_class) { double }
 # let(:checker_2) { double }
 # let(:checker_2_class) { double }
  
 # before do
 #   allow(checker_1).to receive(:class).and_return(checker_1_class)
 #   allow(checker_1_class).to receive(:deactivation_message).and_return("deactivate 1")
 #   allow(checker_2).to receive(:class).and_return(checker_2_class)
 #   allow(checker_2_class).to receive(:deactivation_message).and_return("deactivate 2")
 # end
  
  
  describe "#checkers" do

    context "with no checker" do
      subject { CheckerResults.new }

      its(:checkers) { should eq([]) }
    end
    
    context "with a checker" do
      subject { CheckerResults.new }
      
      before do
        subject.record_checker(checker_1)
      end

      its(:checkers).should equal([checker_1])
    end

    context "with two checkers" do
      subject { CheckerResults.new }
      
      before do
        subject.record_checker(checker_1)
        subject.record_checker(checker_2)
      end

      its(:checkers).should equal([checker_1, checker_2])
    end
  end

  describe "#errors?" do
    context "with no checker" do
      subject { CheckerResults.new }

      its(:errors).should be_falsey
    end
    
    context "with an erroring checker" do
      subject { CheckerResults.new }
      
      before do
        allow(checker_1).to receive(:errors?).and_return(true)
        subject.record_checker(checker_1)
      end

      its(:errors?).should be_truthy
    end

    context "with a non-erroring checker" do

      before do
        allow(checker_1).to receive(:errors?).and_return(false)
        subject.record_checker(checker_1)
      end

      its(:errors?).should be_falsey
    end

    context "with two checkers, both false" do
      before do
        subject { CheckerResults.new }
        allow(checker_1).to receive(:errors?).and_return(false)
        allow(checker_1).to receive(:errors?).and_return(false)
        subject.record_checker(checker_1)
        subject.record_checker(checker_2)
      end

      its(:errors).should be_falsey
    end

    context "with two checkers, one false and one true" do
      before do
        subject { CheckerResults.new }
        allow(checker_1).to receive(:errors?).and_return(false)
        allow(checker_1).to receive(:errors?).and_return(true)
        subject.record_checker(checker_1)
        subject.record_checker(checker_2)
      end

      its(:errors).should be_truthy
    end
  end

  describe "#puts" do

    context "with a checker which returns errors for this project" do
      before do
        subject { CheckerResults.new }
        allow(checker_1).to receive(:errors?).and_return(false)
        allow(checker_1).to receive(:checkers).and_return([])
        expect(checker_1).to receive(:errors?)
        expect(checker_1).to_not receive(:messages)
        expect(checker_1_class).to_not receive(:deactivation_message)
        subject.record_checker(checker_1)
      end

      it "should work" do
        expect(puts(subject)).to be_nil
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
        subject.record_checker(checker_1)
      end

      it "should work" do
        expect(puts(subject)).to be_nil
      end
    end

    context "with a checker whithout a deactivation message" do
      before do
        allow(checker_1).to receive(:errors?).and_return(true)
        allow(checker_1).to receive(:messages).and_return(['a', 'b'])
        allow(checker_1).to receive(:deactivation_message).and_return(nil)
        allow(checker_1_class).to receive(:respond_to?).with(:deactivation_message).and_return(false)
        expect(checker_1).to receive(:errors?)
        expect(checker_1).to receive(:messages)
        expect(checker_1_class).to_not receive(:deactivation_message)
        subject.record_checker(checker_1)
      end

      it "should work" do
        expect(puts(subject)).to be_nil
      end
    end
  end
end
