require "simple_deactivatable_regexp_checker"

class RspecIsExpectedToChecker < SimpleDeactivatableRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-is-expected-to",
      regexp: /is_expected.to/,
      warning_message: %{Warning: RSpec 2.x "should" is preferred to RSpec 3.x "is_expected.to" in #{@file}}
    }
    super(opts.merge(merge_in))
  end
end
