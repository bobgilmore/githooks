module PreCommitHelper

  def self.project_type(toplevel = `git rev-parse --show-toplevel`.strip)
    return :ruby if File.exist?(File.join(toplevel, 'Gemfile'))
    return :node if File.exist?(File.join(toplevel, 'package.json'))
    return :xcode if Dir.glob(File.join(toplevel, '*.xcodeproj')).any?
    return nil
  end

  def self.check_file?(file, extensions_to_ignore = [])
    !extensions_to_ignore.include?(File.extname(file))
  end

  def self.check_file_in_directory?(file, directory, extensions_to_ignore = [])
    PreCommitHelper.check_file?(file, extensions_to_ignore) && !PreCommitHelper.directory_excluded_from_checks?(directory)
  end

  def self.deactivation_message(to_permanently_blank_for_repo, key)
    %{\nTo permanently #{to_permanently_blank_for_repo} for this repo, run\ngit config hooks.#{key} false\n\nTo permanently #{to_permanently_blank_for_repo} for *all* repos, run\ngit config --global hooks.#{key} false\n}
  end

  def self.directory_excluded_from_checks?(directory)
    !!(/assets\// =~ directory && /\/vendor/ =~ directory)
  end

  def self.git_config_val_for_hook(hook_name)
    `git config hooks.#{hook_name}`.strip
  end

  def self.output_error_messages(checker)
    checker.messages.each { |e| puts(e) }
  end

  def self.run_checker(error_found, checker)
    ret = error_found
    if checker.errors?
      ret = true
      PreCommitHelper::output_error_messages(checker)
      puts(checker.class.method(:deactivation_message).call) if checker.class.respond_to?(:deactivation_message)
    end
    ret
  end

end
