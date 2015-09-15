load "pre_commit/pre_commit_helper.rb"
require "spec_helper"

RSpec.describe PreCommitHelper do
  describe ".directory_excluded_from_all_checks?" do
    it "should return false for a random directory" do
      expect(PreCommitHelper.directory_excluded_from_all_checks?("/home/foo/bar")).to be_falsey
    end

    it "should return true for an assets/**/vendor directory" do
      expect(PreCommitHelper.directory_excluded_from_all_checks?("/my/dir/assets/images/vendor/foo")).to be_truthy
    end

    it "should return false for an assets directory" do
      expect(PreCommitHelper.directory_excluded_from_all_checks?("/my/dir/assets/foo")).to be_falsey
    end
  end

  describe ".check_file_based_on_extension?" do
    it "should return true if no extensions are specified" do
      expect(PreCommitHelper.check_file_based_on_extension?(file: "/home/foo/bar.a")).to be_truthy
    end

    it "should return true if there is a match to extensions_to_include" do
      expect(PreCommitHelper.check_file_based_on_extension?(file: "/home/foo/bar.a", extensions_to_include: [".a", ".b"])).to be_truthy
    end

    it "should return false if there is a match to extensions_to_include" do
      expect(PreCommitHelper.check_file_based_on_extension?(file: "/home/foo/bar.a", extensions_to_include: [".c", ".d"])).to be_falsey
    end

    it "should return false if there is a match to extensions_to_ignore" do
      expect(PreCommitHelper.check_file_based_on_extension?(file: "/home/foo/bar.a", extensions_to_ignore: [".a", ".b"])).to be_falsey
    end

    it "should return true if there is a match to extensions_to_ignore" do
      expect(PreCommitHelper.check_file_based_on_extension?(file: "/home/foo/bar.a", extensions_to_ignore: [".c", ".d"])).to be_truthy
    end

    it "should raise an error is both extensions_to_include and extensions_to_ignore are included" do
      expect { PreCommitHelper.check_file_based_on_extension?(file: "/home/foo/bar.a", extensions_to_ignore: [".a"], extensions_to_include: [".b"]) }.to raise_error
    end
  end

  describe ".deactivation_message" do
    it "should return a valid disabling message" do
      expect(PreCommitHelper.deactivation_message("disable", "foo")).to include("To permanently disable for this repo, run\ngit config hooks.foo false")
    end
  end

  describe ".project_type" do
    let(:sample_dir) { "#{File.dirname(__FILE__)}/sample_projects" }

    context "in a ruby directory" do
      let(:dir) { project_dir("ruby") }

      it "should return :ruby" do
        expect(PreCommitHelper.project_type(dir)).to eq :ruby
      end
    end

    context "in a node directory" do
      let(:dir) { project_dir("node") }

      it "should return :node" do
        expect(PreCommitHelper.project_type(dir)).to eq :node
      end
    end

    context "in an xcode directory" do
      let(:dir) { project_dir("xcode") }

      it "should return :xcode" do
        expect(PreCommitHelper.project_type(dir)).to eq :xcode
      end
    end

    context "in an unknown directory" do
      let(:dir) { project_dir("unknown") }

      it "should return nil" do
        expect(PreCommitHelper.project_type(dir)).to be_falsey
      end
    end
  end

  describe ".run_checker" do
    let(:checker) { double }
    let(:checker_class) { double }

    before do
      allow(checker).to receive(:class).and_return(checker_class)
      allow(checker_class).to receive(:deactivation_message).and_return("This is how we deactivate.")
    end

    context "with a checker which doesn't return errors for this project" do
      before do
        allow(checker).to receive(:errors?).and_return(false)
        allow(checker).to receive(:messages).and_return([])
        expect(checker).to receive(:errors?)
        expect(checker).to_not receive(:messages)
        expect(checker_class).to_not receive(:deactivation_message)
      end
    end

    context "with a checker which returns errors for this project" do
      before do
        allow(checker).to receive(:errors?).and_return(true)
        allow(checker).to receive(:messages).and_return(['a', 'b'])
        allow(checker).to receive(:deactivation_message).and_return(nil)
        expect(checker).to receive(:errors?)
        expect(checker).to receive(:messages)
        expect(checker_class).to receive(:deactivation_message)
      end
    end

    context "with a checker without a deactivation message" do
      before do
        allow(checker).to receive(:errors?).and_return(true)
        allow(checker).to receive(:messages).and_return(['a', 'b'])
        allow(checker).to receive(:deactivation_message).and_return(nil)
        allow(checker_class).to receive(:respond_to?).with(:deactivation_message).and_return(false)
        expect(checker).to receive(:errors?)
        expect(checker).to receive(:messages)
        expect(checker_class).to_not receive(:deactivation_message)

      end
    end
  end

  def project_dir(project_type)
    "#{File.dirname(__FILE__)}/sample_projects/#{project_type}_project"
  end
end
