class StrictParenSpacingChecker
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
    if !SHELL_SCRIPT_EXTENSIONS.include?(File.extname(@file)) && !PreCommitHelper.directory_excluded_from_checks?(@dir)
      mess << warning_message(OPEN_SMOOTH_SPACE)  if @changed_code.match(OPEN_SMOOTH_SPACE_REGEXP)
      mess << warning_message(SPACE_CLOSE_SMOOTH) if @changed_code.match(SPACE_CLOSE_SMOOTH_REGEXP)
      mess << warning_message(OPEN_SQUARE_SPACE)  if @changed_code.match(OPEN_SQUARE_SPACE_REGEXP)
      mess << warning_message(SPACE_CLOSE_SQUARE) if @changed_code.match(SPACE_CLOSE_SQUARE_REGEXP)
    end
    mess
  end

  private

  def self.use_for_project?
    val = PreCommitHelper.git_config_val_for_hook(HOOK_KEY)
    val.empty? || (val == 'true') || @pref_on
  end

  def warning_message(bad_expression)
    %{Warning: git pre-commit hook is suspicious of committing lines with "#{bad_expression}" to #{@file}\nThis may be OK, or not, depending on your project requirements.}
  end

  HOOK_KEY = "requirestrictparenspacing"

  SHELL_SCRIPT_EXTENSIONS = [ '.sh', '.bash', '' ]

  OPEN_SMOOTH_SPACE  = "( "
  SPACE_CLOSE_SMOOTH = " )"
  OPEN_SQUARE_SPACE  = "[ "
  SPACE_CLOSE_SQUARE = " ]"

  OPEN_SMOOTH_SPACE_REGEXP  = /\([ \t]+/
  SPACE_CLOSE_SMOOTH_REGEXP = /[ \t]+\)/
  OPEN_SQUARE_SPACE_REGEXP  = /\[[ \t]+/
  SPACE_CLOSE_SQUARE_REGEXP = /[ \t]+\]/

end
