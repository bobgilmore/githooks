class ForbiddenStringChecker
  attr_reader :messages

  def initialize(opts)
    @file = opts[:file]
    @changed_code = opts[:changes]
    @project_type = opts[:project_type]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    FORBIDDEN_STRINGS.each do |re|
      mess << %{"#{$1 || $&}" in #{@file}} if @changed_code.match(re)
    end
    if @project_type != :node
      FORBIDDEN_STRINGS_EXCEPT_IN_NODE.each do |re2|
        if @changed_code.match(re2)
          mess << %{"#{$1 || $&}" in #{@file} outside of Node.js projects.\nIf this *is* a Node project, run\n\nnpm init\n\nat the top level of the project to add a package.json file. See\nhttps://devcenter.heroku.com/articles/getting-started-with-nodejs#declare-dependencies-with-npm\nfor more information.}
        end
      end
    end
    mess
  end

  private

  FORBIDDEN_STRINGS = [
    /^>>>>>>/, # Git conflict markers
    /^======/, # "
    /^<<<<<</, # "
    /binding\.pry/, # pry debugging code
    /binding\.remote_pry/, # "
    /byebug/, # Ruby >= 2.0 debugging code
    /debugger/, # Ruby < 2.0 debugging code, JS debugging code.
    /logger\.debug/, # I almost never want to commit a (Ruby) call to logger.debug.  error, message, etc., but not debug.
    /save_and_open_page/, # Capybara debugging
    /save_and_open_screenshot/, # "
    /save_screenshot/, # "
    /TMP_DEBUG/ # My TextExpander macros for embedding debug code always include this for easy scanning.
  ]

  FORBIDDEN_STRINGS_EXCEPT_IN_NODE = [
    /console\.\w*/,  # JavaScript debug code that would break IE.
  ]

end
