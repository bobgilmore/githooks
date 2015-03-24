require "simple_deactivatable_regexp_checker"

class RspecExpectToReceiveChecker < SimpleDeactivatableRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbidexpecttoreceive",
      regexp: /expect.+\.to(_not)?\sreceive/,
      warning_message: %{Warning: git pre-commit hook prefers "allow(foo).to[_not] receive" in a "before" block, \nfollowed by "expect(foo).to[_not] have_received" in an "its" block, \nto "expect(foo).to[_not] receive"}
    }
    super(opts.merge(merge_in))
  end
end
