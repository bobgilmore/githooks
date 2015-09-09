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
    if PreCommitHelper.check_file_in_directory?(file: @file, directory: @dir, extensions_to_ignore: EXTENSIONS_TO_IGNORE)
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

  EXTENSIONS_TO_IGNORE = ['.m', '.swift']

  FLASH = /flash\s*\[\s*:alert\s*\]/
  ALERT = /alert/

end
