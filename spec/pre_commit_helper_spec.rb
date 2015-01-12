load "pre_commit_helper.rb"

RSpec.describe PreCommitHelper do

  describe ".directory_excluded_from_checks?" do
    it "should return false for a random directory" do
      expect(PreCommitHelper::directory_excluded_from_checks?("/home/foo/bar")).to be_falsey
    end

    it "should return true for an assets/**/vendor directory" do
      expect(PreCommitHelper::directory_excluded_from_checks?("/my/dir/assets/images/vendor/foo")).to be_truthy
    end

    it "should return false for an assets directory" do
      expect(PreCommitHelper::directory_excluded_from_checks?("/my/dir/assets/foo")).to be_falsey
    end
  end

  describe ".deactivation_message" do
    it "should return a valid disabling message" do
      expect(PreCommitHelper::deactivation_message("disable", "foo", "bar")).to include("To permanently disable for this repo, run\ngit config hooks.foo bar")
    end
  end

  describe ".project_type" do
    it "should return nil" do
      expect(PreCommitHelper::project_type).to include("ruby")
    end
  end
  
end
