# Check that we don't use spaces after opening braces or before closing braces.  This is required in some of my projects.

class StrictParenSpacingChecker
  SHELL_SCRIPT_EXTENSIONS = [ '.sh', '.bash', '' ]

  OPEN_SMOOTH_SPACE  = /\([ \t]+/
  SPACE_CLOSE_SMOOTH = /[ \t]+\)/
  OPEN_SQUARE_SPACE  = /\[[ \t]+/
  SPACE_CLOSE_SQUARE = /[ \t]+\]/

  def self.necessary?
    undefined = `git config hooks.requirestrictparenspacing`.strip.empty?
    undefined || (`git config hooks.requirestrictparenspacing`.strip == 'true')
  end

  def check(dir, file, changed_code_for_file)
    if !SHELL_SCRIPT_EXTENSIONS.include?(File.extname(file)) && !(/assets\// =~ dir && /\/vendor/ =~ dir)
      if changed_code_for_file.match(OPEN_SMOOTH_SPACE)
        puts %{Warning: git pre-commit hook is suspicious of committing lines with "( " to #{file}\nThis may be OK, or not, depending on your project requirements.}
        puts PreCommitHelper::deactivation_message("allow", "requirestrictparenspacing", false)
        error_found = true
      end
      if changed_code_for_file.match(SPACE_CLOSE_SMOOTH)
        puts %{Warning: git pre-commit hook is suspicious of committing lines with " )" to #{file}\nThis may be OK, or not, depending on your project requirements.}
        puts PreCommitHelper::deactivation_message("allow", "requirestrictparenspacing", false)
        error_found = true
      end
      if changed_code_for_file.match(OPEN_SQUARE_SPACE)
        puts %{Warning: git pre-commit hook is suspicious of committing lines with "[ " to #{file}\nThis may be OK, or not, depending on your project requirements.}
        puts PreCommitHelper::deactivation_message("allow", "requirestrictparenspacing", false)
        error_found = true
      end
      if changed_code_for_file.match(SPACE_CLOSE_SQUARE)
        puts %{Warning: git pre-commit hook is suspicious of committing lines with " ]" to #{file}\nThis may be OK, or not, depending on your project requirements.}
        puts PreCommitHelper::deactivation_message("allow", "requirestrictparenspacing", false)
        error_found = true
      end
    end
  end

end
