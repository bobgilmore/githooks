class RubyVersionChecker
  attr_reader :messages

  HOOK_KEY = "allow-ruby-version-change"

  def self.deactivation_message
    PreCommitHelper.deactivation_message("allow", HOOK_KEY, true)
  end

  def initialize(opts)
    @files = opts[:files]
    @pref_on = !!opts[:pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    return [] unless self.class.use_for_project?
    mess = []
    @files.each do |file|
      base = File.basename(file)
      if base == '.ruby-version' || base == '.rbenv-version'
        mess << %{Edit to #{base} - you probably didn't mean to do that.}
      end
    end
    mess
  end

  private

  def self.use_for_project?
    val = PreCommitHelper.git_config_val_for_hook(HOOK_KEY)
    val.empty? || (val == 'false') || @pref_on
  end

end
