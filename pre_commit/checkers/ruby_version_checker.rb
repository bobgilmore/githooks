class RubyVersionChecker
  attr_reader :messages

  def initialize(opts)
    @file = opts[:file]
    @force_pref_on = opts[:force_pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    mess << %{Edit to #{@file} - you probably didn't mean to do commit that.} if file_is_forbidden?
    mess
  end
  
  private
  
  def file_is_forbidden?
    @file == '.ruby-version' || @file == '.rbenv-version'
  end
end
