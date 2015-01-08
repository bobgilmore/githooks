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
end
