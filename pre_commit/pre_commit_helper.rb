module PreCommitHelper
  EXTENSIONS_RUBY = [".rb"]

  def self.project_type(toplevel = `git rev-parse --show-toplevel`.strip)
    # puts (File.join(toplevel, '*', 'Gemfile'))
    # if File.exist?(File.join(toplevel, 'Gemfile')) || File.exist?(File.join(toplevel, '*', 'Gemfile'))
    #   return :ruby
    # end
    if Dir.glob(File.join(toplevel, '*.xcodeproj')).any? || Dir.glob(File.join(toplevel, '*', '*.xcodeproj')).any?
      return :xcode
    end
    return :ruby if file_exists_at_top_or_one_deep(toplevel, 'Gemfile')
    return :node if file_exists_at_top_or_one_deep(toplevel, 'package.json')
  end

  def self.check_file_based_on_extension?(params)
    raise "extension_to_include and extensions_to_ignore are both included. Behavior undetermined." if params[:extensions_to_check] && params[:extensions_to_ignore]
    ext = File.extname(params[:file])
    if params[:extensions_to_check]
      params[:extensions_to_check].include?(ext)
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
    %{\nTo permanently #{to_permanently_blank_for_repo} for this repo, run\ngit config hooks.#{key} false\n\nTo permanently #{to_permanently_blank_for_repo} for *all* repos, run\ngit config --global hooks.#{key} false\n} if key
  end

  def self.directory_excluded_from_all_checks?(directory)
    !!(/assets\// =~ directory && /\/vendor/ =~ directory)
  end

  def self.disabled_via_preference?(hook_key, force_pref_on = false)
    val = PreCommitHelper.git_config_val_for_hook(hook_key)
    !(val.empty? || (val == 'true') || force_pref_on)
  end

  def self.git_config_val_for_hook(hook_name)
    hook_name ? `git config hooks.#{hook_name}`.strip : ""
  end

  def self.output_error_messages(checker)
    checker.messages.each { |e| puts(e) }
  end

  #if File.exist?(File.join(toplevel, 'Gemfile')) || File.exist?(File.join(toplevel, '*', 'Gemfile'))
  def self.file_exists_at_top_or_one_deep(toplevel, filename)
    return true if File.exist?(File.join(toplevel, filename))
    Dir.glob(File.join(toplevel, '*')).each do |dir|
      return true if File.exist?(File.join(dir, filename))
    end
    false
  end

  def self.checker_classes
    return @checker_classes if @checker_classes
    @checker_classes = []
    checker_file_spec = File.dirname(__FILE__) + "/checkers/*_checker.rb"
    Dir.glob(checker_file_spec).each do |checker_file|
      file_name = File.basename(checker_file, ".rb")
      class_name = file_name.gsub(/^[a-z0-9]|_[a-z0-9]/) { |a| a.upcase }.gsub(/_/, "")
      @checker_classes << Object.const_get(class_name)
    end
    @checker_classes
  end
end
