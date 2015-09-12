class SyntaxRubyChecker
  attr_reader :messages

  def self.deactivation_message
    PreCommitHelper.deactivation_message("deactivate", HOOK_KEY)
  end

  def initialize(opts)
    @toplevel = opts[:toplevel]
    @files = opts[:files]
    @force_pref_on = opts[:force_pref_on]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    return [] if disabled_via_preference?
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

  def disabled_via_preference?
    PreCommitHelper.disabled_via_preference?(HOOK_KEY, @force_pref_on)
  end

  def warning_message(fullfile)
    %{Syntax error in #{fullfile}.\nIf this flags valid code, you may be using an old system git.\n(Using #{`git --version`})}
  end

  HOOK_KEY = "check-ruby-syntax"
end
