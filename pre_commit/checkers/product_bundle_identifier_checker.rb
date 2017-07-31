class ProductBundleIdentifierChecker
  attr_reader :messages

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    PRODUCT_BUNDLE_IDENTIFIER_INDICATORS.each do |re|
      if @changed_code.match(re)
        mess << %{Probable product bundle identifer change "#{$1 || $&}" in #{@file}}
      end
    end
    mess
  end

  private

  PRODUCT_BUNDLE_IDENTIFIER_INDICATORS = [
    /PRODUCT_BUNDLE_IDENTIFIER = /
  ]
end
