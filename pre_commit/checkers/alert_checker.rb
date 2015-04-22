class AlertChecker
  attr_reader :messages

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code_array = opts[:changes]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    if !EXTENSIONS_TO_IGNORE.include?(File.extname(@file)) && !PreCommitHelper.directory_excluded_from_checks?(@dir)
      @changed_code_array.each do |changed_code_line|
        if changed_code_line.match(ALERT) && !changed_code_line.match(FLASH)
          mess << warning_message()
        end
      end
    end
    mess
  end

  private

  def warning_message
    %{"alert" in #{@file}}
  end

  EXTENSIONS_TO_IGNORE = [ '.m', '.swift']

  FLASH = /flash\s*\[\s*:alert\s*\]/
  ALERT = /alert/

end
