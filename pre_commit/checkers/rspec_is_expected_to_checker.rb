class RspecIsExpectedToChecker
  attr_reader :messages

  def self.deactivation_message
    PreCommitHelper.deactivation_message("allow", HOOK_KEY, false)
  end

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @pref_on = !!opts[:pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    return [] unless self.class.use_for_project?
    mess = []
    if !PreCommitHelper.directory_excluded_from_checks?(@dir)
      mess << warning_message if @changed_code.match(REGEXP)
    end
    mess
  end

  private

  def self.use_for_project?
    val = PreCommitHelper.git_config_val_for_hook(HOOK_KEY)
    val.empty? || (val == 'true') || @pref_on
  end

  def warning_message
    %{Warning: git pre-commit hook prefers RSpec 2.x "should" to RSpec 3.x "is_expected.to" in #{@file}\nThis may be OK, or not, depending on your project requirements.}
  end

  HOOK_KEY = "forbidisexpectedto"

  REGEXP = /is_expected.to/

end
