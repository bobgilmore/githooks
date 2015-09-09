require "simple_deactivatable_regexp_checker"

class RspecToNotChecker < SimpleDeactivatableRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-to-not",
      regexp: /\.to_not/,
      extensions_to_include: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{RSpec ".not_to" is preferred over ".to_not" in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
