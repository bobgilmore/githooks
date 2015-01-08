class PreCommitHelper

  def self.project_type
    toplevel = `git rev-parse --show-toplevel`.strip
    gemfile = File.join(toplevel, 'Gemfile')
    return 'ruby' if File.exist?(gemfile)
    package_json = File.join(toplevel, 'package.json')
    return 'node' if File.exist?(package_json)
    return nil
  end

  def self.deactivation_message(to_permanently_blank_for_repo, key, value)
    %{\nTo permanently #{to_permanently_blank_for_repo} for this repo, run\ngit config hooks.#{key} #{value}\nand try again.\n\nTo permanently #{to_permanently_blank_for_repo} it for *all* repos, run\ngit config --global hooks.#{key} #{value}\nand try again.\n--------------}
  end

  def self.directory_excluded_from_checks?(directory)
    !!(/assets\// =~ directory && /\/vendor/ =~ directory)
  end

end
