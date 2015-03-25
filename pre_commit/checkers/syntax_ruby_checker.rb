class SyntaxRubyChecker
  attr_reader :messages

  def self.deactivation_message
    PreCommitHelper.deactivation_message("deactivate", HOOK_KEY, false)
  end

  def initialize(opts)
    @toplevel = opts[:toplevel]
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
      if File.extname(file) == '.rb'
        fullfile = File.join(@toplevel.strip, file)
        if File.exist?(fullfile)
          output = `ruby -c #{fullfile}`
          status = $?.success?
          mess <<  warning_message(fullfile) unless status
        end
      end
    end
    mess
  end
  
  private

  def self.use_for_project?
    val = PreCommitHelper.git_config_val_for_hook(HOOK_KEY)
    val.empty? || (val == 'true') || @pref_on
  end

  def warning_message(fullfile)
    %{Error: git pre-commit hook found a syntax error in #{fullfile}.\nIf you find that this check is flagging valid code too often, you may be using an old system git to perform the syntax check.}
  end

  HOOK_KEY = "check-ruby-syntax"
end
