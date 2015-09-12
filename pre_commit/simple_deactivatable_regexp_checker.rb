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
    return [] if directory_excluded_from_all_checks?
    return [] if disabled_via_preference?
    return [] unless check_file_based_on_extension?
    message = []
    message << @warning_message if @changed_code.match(@regexp)
    message
  end

  private

  def directory_excluded_from_all_checks?
    PreCommitHelper.directory_excluded_from_all_checks?(@dir)
  end

  def disabled_via_preference?
    PreCommitHelper.disabled_via_preference?(@hook_key, @force_pref_on)
  end

  def check_file_based_on_extension?
    PreCommitHelper.check_file_based_on_extension?(file: @file,
      extensions_to_include: @extensions_to_include,
      extensions_to_exclude: @extensions_to_exclude)
  end
end
