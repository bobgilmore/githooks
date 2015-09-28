require "simple_regexp_checker"

class RspecIsExpectedToChecker < SimpleRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-is-expected-to",
      regexp_code: /is_expected\.to/,
      extensions_to_check: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{RSpec "should" is preferred over "is_expected.to" in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
