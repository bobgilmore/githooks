class StrictParenSpacingChecker
  attr_reader :messages

  def self.deactivation_message
    PreCommitHelper.deactivation_message("allow", HOOK_KEY)
  end

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @project_type = opts[:project_type]
    @force_pref_on = opts[:force_pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    return [] if @project_type == :xcode
    return [] if disabled_via_preference?
    mess = []
    if PreCommitHelper.check_file_in_directory?(file: @file, directory: @dir, extensions_to_ignore: EXTENSIONS_TO_IGNORE_ALL)
      mess << warning_message(OPEN_SMOOTH_SPACE) if @changed_code.match(OPEN_SMOOTH_SPACE_REGEXP)
      mess << warning_message(SPACE_CLOSE_SMOOTH) if @changed_code.match(SPACE_CLOSE_SMOOTH_REGEXP)
      if PreCommitHelper.check_file_in_directory?(file: @file, directory: @dir, extensions_to_ignore: EXTENSIONS_TO_IGNORE_SQUARE)
        mess << warning_message(OPEN_SQUARE_SPACE) if @changed_code.match(OPEN_SQUARE_SPACE_REGEXP)
        mess << warning_message(SPACE_CLOSE_SQUARE) if @changed_code.match(SPACE_CLOSE_SQUARE_REGEXP)
      end
    end
    mess
  end

  private

  def disabled_via_preference?
    PreCommitHelper.disabled_via_preference?(HOOK_KEY, @force_pref_on)
  end

  def warning_message(bad_expression)
    %{Lines with "#{bad_expression}" in #{@file}.}
  end

  HOOK_KEY = "require-strict-paren-spacing"

  SHELL_EXTENSIONS = ['.sh', '.bash', '']
  EXTENSIONS_TO_IGNORE_ALL = SHELL_EXTENSIONS

  ELIXIR_EXTENSIONS = [".ex", ".exs"]
  EXTENSIONS_TO_IGNORE_SQUARE = ELIXIR_EXTENSIONS

  OPEN_SMOOTH_SPACE  = "( "
  SPACE_CLOSE_SMOOTH = " )"
  OPEN_SQUARE_SPACE  = "[ "
  SPACE_CLOSE_SQUARE = " ]"

  OPEN_SMOOTH_SPACE_REGEXP  = /\([ \t]+/
  SPACE_CLOSE_SMOOTH_REGEXP = /[ \t]+\)/
  OPEN_SQUARE_SPACE_REGEXP  = /\[[ \t]+/
  SPACE_CLOSE_SQUARE_REGEXP = /[ \t]+\]/

end
