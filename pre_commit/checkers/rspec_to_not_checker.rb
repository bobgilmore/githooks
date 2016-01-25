require "simple_regexp_checker"

class RspecToNotChecker < SimpleRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-to-not",
      regexp_code: /\.to_not/,
      extensions_to_check: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{RSpec ".not_to" is preferred over ".to_not" in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
