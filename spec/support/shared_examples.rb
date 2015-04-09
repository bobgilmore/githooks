RSpec.shared_examples "it finds an error" do
  describe "#errors?" do
    it "should have an error" do
      expect(checker.errors?).to be_truthy
    end
  end

  describe "#messages" do
    it "should have one message" do
      expect(checker.messages.count).to eq 1
    end
  end
end

RSpec.shared_examples "it finds two errors" do
  describe "#errors?" do
    it "should have an error" do
      expect(checker.errors?).to be_truthy
    end
  end

  describe "#messages" do
    it "should have one message" do
      expect(checker.messages.count).to eq 2
    end
  end
end

RSpec.shared_examples "it finds no error" do
  describe "#errors?" do
    it "should not have an error" do
      expect(checker.errors?).to be_falsey
    end
  end

  describe "#messages" do
    it "should have no messages" do
      expect(checker.messages).to be_empty
    end
  end
end
