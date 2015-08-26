require "simple_deactivatable_regexp_checker"

class RspecToNotChecker < SimpleDeactivatableRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-to-not",
      regexp: /\.to_not/,
      warning_message: %{RSpec ".not_to" is preferred over ".to_not" in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
