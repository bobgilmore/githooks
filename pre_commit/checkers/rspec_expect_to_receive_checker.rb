class RspecExpectToReceiveChecker
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
    %{Warning: git pre-commit hook prefers "allow(foo).to[_not] receive" in a "before" block, \nfollowed by "expect(foo).to[_not] have_received" in an "its" block, \nto "expect(foo).to[_not] receive" in #{@file}}
  end

  HOOK_KEY = "forbidexpecttoreceive"

  REGEXP = /expect.+\.to(_not)?\sreceive/

end
