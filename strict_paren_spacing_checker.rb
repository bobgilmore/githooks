# Check that we don't use spaces after opening braces or before closing braces.  This is required in some of my projects.

class StrictParenSpacingChecker
  attr_reader :messages

  def self.use_for_project?
    preference_for_project?
  end

  def initialize(dir, file, changed_code)
    @dir = dir
    @file = file
    @messages = examine_code(changed_code)
  end

  def errors?
    !@messages.empty?
  end

  def examine_code(changed_code)
    mess = [ ]
    if !SHELL_SCRIPT_EXTENSIONS.include?(File.extname(@file)) && !PreCommitHelper::directory_excluded_from_checks?(@dir)
      mess << warning_message(@file, OPEN_SMOOTH_SPACE)  if changed_code.match(OPEN_SMOOTH_SPACE_REGEXP)
      mess << warning_message(@file, SPACE_CLOSE_SMOOTH) if changed_code.match(SPACE_CLOSE_SMOOTH_REGEXP)
      mess << warning_message(@file, OPEN_SQUARE_SPACE)  if changed_code.match(OPEN_SQUARE_SPACE_REGEXP)
      mess << warning_message(@file, SPACE_CLOSE_SQUARE) if changed_code.match(SPACE_CLOSE_SQUARE_REGEXP)
    end
    mess << PreCommitHelper::deactivation_message("allow", "requirestrictparenspacing", false) unless mess.empty?
    mess
  end

  def self.preference_for_project?
    val = `git config hooks.requirestrictparenspacing`.strip
    val.empty? || (val == 'true')
  end

  def warning_message(file, bad_expression)
    %{Warning: git pre-commit hook is suspicious of committing lines with "#{bad_expression}" to #{file}\nThis may be OK, or not, depending on your project requirements.}
  end

  private

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
