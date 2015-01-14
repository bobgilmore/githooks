# Check that we don't use alerts inappropriately

class AlertChecker
  require './pre_commit_helper.rb'

  attr_reader :messages

  def self.use_for_project?
    true
  end

  def initialize(dir, file, changed_code)
    @dir = dir
    @file = file
    @changed_code = changed_code
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    if !PreCommitHelper.directory_excluded_from_checks?(@dir)
      if @changed_code.match(ALERT) && !@changed_code.match(FLASH)
        mess << warning_message()
      end
    end
    mess
  end

  def warning_message
    %{Warning: git pre-commit hook is suspicious of committing lines with "alert" to #{@file}\n--------------}
  end

  private

  FLASH = /flash\s*\[\s*:alert\s*\]/
  ALERT = /alert/

end
