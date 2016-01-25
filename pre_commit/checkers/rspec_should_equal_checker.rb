require "simple_regexp_checker"

class RspecShouldEqualChecker < SimpleRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-rspec-should-equal",
      regexp_code: /should(?:_not)?\s*[!=]=/,
      extensions_to_check: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message:  %{"should ==", "should_not ==", or "should !=" in #{opts[:file]}".\nReplace with "should eq" or "should_not eq"}
    }
    super(opts.merge(merge_in))
  end
end
