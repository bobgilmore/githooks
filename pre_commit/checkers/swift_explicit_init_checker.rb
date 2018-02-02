require "simple_regexp_checker"

class SwiftExplicitInitChecker < SimpleRegexpChecker

  def initialize(opts)
    merge_in = {
      hook_key: "forbid-swift-explicit-init",
      regexp_code: /\.init\(/,
      extensions_to_check: PreCommitHelper::EXTENSIONS_SWIFT,
      warning_message: %{"Explicit call to .init in Swift file.}
    }
    super(opts.merge(merge_in))
  end
end
