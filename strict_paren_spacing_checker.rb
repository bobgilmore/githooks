# Check that we don't use spaces after opening braces or before closing braces.  This is required in some of my projects.

class StrictParenSpacingChecker
  SHELL_SCRIPT_EXTENSIONS = [ '.sh', '.bash', '' ]

  OPEN_SMOOTH_SPACE  = "( "
  SPACE_CLOSE_SMOOTH = " )"
  OPEN_SQUARE_SPACE  = "[ "
  SPACE_CLOSE_SQUARE = " ]"

  OPEN_SMOOTH_SPACE_REGEXP  = /\([ \t]+/
  SPACE_CLOSE_SMOOTH_REGEXP = /[ \t]+\)/
  OPEN_SQUARE_SPACE_REGEXP  = /\[[ \t]+/
  SPACE_CLOSE_SQUARE_REGEXP = /[ \t]+\]/

  def self.necessary?
    val = `git config hooks.requirestrictparenspacing`.strip
    val.empty? || (val == 'true')
  end

  def check(dir, file, changed_code_for_file)
    messages = [ ]
    deactivation_message = PreCommitHelper::deactivation_message("allow", "requirestrictparenspacing", false)
    
    if !SHELL_SCRIPT_EXTENSIONS.include?(File.extname(file)) && !PreCommitHelper::directory_excluded_from_checks?(dir)
      if changed_code_for_file.match(OPEN_SMOOTH_SPACE_REGEXP)
        messages << warning_message(file, OPEN_SMOOTH_SPACE)
        messages << deactivation_message
      end
      if changed_code_for_file.match(SPACE_CLOSE_SMOOTH_REGEXP)
        messages << warning_message(file, SPACE_CLOSE_SMOOTH)
        messages << deactivation_message
      end
      if changed_code_for_file.match(OPEN_SQUARE_SPACE_REGEXP)
        messages << warning_message(file, OPEN_SQUARE_SPACE)
        messages << deactivation_message
      end
      if changed_code_for_file.match(SPACE_CLOSE_SQUARE_REGEXP)
        messages << warning_message(file, SPACE_CLOSE_SQUARE)
        messages << deactivation_message
      end
    end
    messages
  end

  def warning_message(file, bad_expression)
    %{Warning: git pre-commit hook is suspicious of committing lines with "#{bad_expression}" to #{file}\nThis may be OK, or not, depending on your project requirements.}
  end

end
