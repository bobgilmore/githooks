require "simple_deactivatable_regexp_checker"

class RubyNoThrowChecker < SimpleDeactivatableRegexpChecker
  def initialize(opts)
    merge_in = {
      hook_key: "forbid-ruby-throw",
      regexp: /throw/,
      extensions_to_include: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{Ruby "raise" is preferred over "throw" in #{opts[:file]}}
    }
    super(opts.merge(merge_in))
  end
end
