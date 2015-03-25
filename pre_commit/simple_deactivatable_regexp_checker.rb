class SimpleDeactivatableRegexpChecker
  attr_reader :messages

  def deactivation_message
    PreCommitHelper.deactivation_message("allow", @hook_key, false)
  end

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @hook_key = opts[:hook_key]
    @regexp = opts[:regexp]
    @warning_message = opts[:warning_message]

    @pref_on = !!opts[:pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    return [] unless use_for_project?
    mess = []
    if !PreCommitHelper.directory_excluded_from_checks?(@dir)
      mess << @warning_message if @changed_code.match(@regexp)
    end
    mess
  end

  private

  def use_for_project?
    val = PreCommitHelper.git_config_val_for_hook(@hook_key)
    val.empty? || (val == 'true') || @pref_on
  end

end
