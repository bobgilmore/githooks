require "simple_regexp_checker"

class RspecExpectToReceiveChecker < SimpleRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-expect-to-receive",
      regexp_code: /expect.+\.to(_not)?\sreceive/,
      extensions_to_check: PreCommitHelper::EXTENSIONS_RUBY,
      warning_message: %{"expect(foo).to[_not] receive in #{opts[:file]}".\nWe prefer "allow(foo).to[_not] receive" in a "before" block, \nfollowed by "expect(foo).to[_not] have_received" in an "its" block.}
    }
    super(opts.merge(merge_in))
  end
end
