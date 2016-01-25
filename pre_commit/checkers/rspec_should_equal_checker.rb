require "simple_deactivatable_regexp_checker"

class RspecShouldEqualChecker < SimpleDeactivatableRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-should-equal",
      regexp: /should(?:_not)?\s*[!=]=/,
      extensions_to_include: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message:  %{"should ==", "should_not ==", or "should !=" in #{opts[:file]}".\nReplace with "should eq" or "should_not eq"}
    }
    super(opts.merge(merge_in))
  end
end
