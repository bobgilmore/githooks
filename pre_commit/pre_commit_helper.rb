module PreCommitHelper

  EXTENSIONS_RUBY = [".rb"]

  def self.project_type(toplevel = `git rev-parse --show-toplevel`.strip)
    return :ruby if File.exist?(File.join(toplevel, 'Gemfile'))
    return :node if File.exist?(File.join(toplevel, 'package.json'))
    return :xcode if Dir.glob(File.join(toplevel, '*.xcodeproj')).any?
    return nil
  end

  def self.check_file_based_on_extension?(params)
    raise "extension_to_include and extensions_to_ignore are both included. Behavior undetermined." if !params[:extensions_to_include].nil? && !params[:extensions_to_ignore].nil?
    ext = File.extname(params[:file])
    if params[:extensions_to_include]
      params[:extensions_to_include].include?(ext)
    elsif params[:extensions_to_ignore]
      !params[:extensions_to_ignore].include?(ext)
    else
      true
    end
  end

  def self.check_file_in_directory?(params)
    PreCommitHelper.check_file_based_on_extension?(params) && !PreCommitHelper.directory_excluded_from_all_checks?(params[:directory])
  end

  def self.deactivation_message(to_permanently_blank_for_repo, key)
    %{\nTo permanently #{to_permanently_blank_for_repo} for this repo, run\ngit config hooks.#{key} false\n\nTo permanently #{to_permanently_blank_for_repo} for *all* repos, run\ngit config --global hooks.#{key} false\n}
  end

  def self.directory_excluded_from_all_checks?(directory)
    !!(/assets\// =~ directory && /\/vendor/ =~ directory)
  end

  def self.disabled_via_preference?(hook_key, force_pref_on = false)
    val = PreCommitHelper.git_config_val_for_hook(hook_key)
    !(val.empty? || (val == 'true') || force_pref_on)
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
