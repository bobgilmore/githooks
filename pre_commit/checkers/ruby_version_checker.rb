class RubyVersionChecker
  attr_reader :messages

  def initialize(opts)
    @files = opts[:files]
    @force_pref_on = opts[:force_pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    @files.each do |file|
      base = File.basename(file)
      if base == '.ruby-version' || base == '.rbenv-version'
        mess << %{Edit to #{base} - you probably didn't mean to do that.}
      end
    end
    mess
  end

end
