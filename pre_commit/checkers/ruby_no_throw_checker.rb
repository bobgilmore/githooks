require "simple_regexp_checker"

class RubyNoThrowChecker < SimpleRegexpChecker
  def initialize(opts)
    merge_in = {
      hook_key: "forbid-ruby-throw",
      regexp_code: /throw/,
      extensions_to_include: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{Ruby "raise" is preferred over "throw" in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
