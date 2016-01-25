class PrivateKeyChecker
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
    PRIVATE_KEY_INDICATORS.each do |re|
      if @changed_code.match(re)
        mess << %{Probable private key commit "#{$1 || $&}" to #{@file}}
      end
    end
    mess
  end

  private

  PRIVATE_KEY_INDICATORS = [
    /PRIVATE KEY/,
    /ssh-rsa/
  ]
end
