class SimpleDeactivatableRegexpChecker
  attr_reader :messages

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @hook_key = opts[:hook_key]
    @regexp = opts[:regexp]
    @extensions_to_include = opts[:extensions_to_include]
    @extensions_to_ignore = opts[:extensions_to_ignore]
    @warning_message = opts[:warning_message]

    @force_pref_on = opts[:force_pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    return [] unless use_for_project?
    return [] unless check_file_based_on_extension?
    mess = []
    mess << @warning_message if !PreCommitHelper.directory_excluded_from_all_checks?(@dir) && @changed_code.match(@regexp)
    mess
  end

  private

  def use_for_project?
    val = PreCommitHelper.git_config_val_for_hook(@hook_key)
    val.empty? || (val == 'true') || @force_pref_on
  end

  def check_file_based_on_extension?
    PreCommitHelper.check_file_based_on_extension?(file: @file, extensions_to_include: @extensions_to_include, extensions_to_exclude: @extensions_to_exclude)
  end
end
