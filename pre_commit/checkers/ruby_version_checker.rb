class RubyVersionChecker
  attr_reader :messages

  HOOK_KEY = "allowrubyversionchange"
  
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
        mess << %{Warning: git pre-commit hook found attempt to edit #{base}.\nThis may be OK, or not, depending on your project requirements.}
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
