require "simple_regexp_checker"

class RspecFocusChecker < SimpleRegexpChecker
  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-focus",
      regexp_code: /["'],.*:?focus:?.*do/,
      extensions_to_check: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{Remove :focus from your specs in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
