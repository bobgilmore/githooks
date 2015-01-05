class UserHomeChecker
  attr_reader :messages

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @user = opts[:user] || ENV["USER"]
    @user_home = [
      Regexp.new("/home/#{@user}"),        # Hard-coded path to user's HOME
      Regexp.new("/Users/#{@user}"),       # ''
      Regexp.new("/export/home/#{@user}")  # '' (for a current work config)
    ]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    @user_home.each do |re|
      if @changed_code.match(re)
        mess << %{Error: git pre-commit hook forbids committing what looks like a hard-coded home dir: "#{$1 || $&}" to #{@file}}
      end
    end
    mess
  end
end
