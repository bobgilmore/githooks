class DevelopmentTeamChecker
  attr_reader :messages

  def initialize(opts)
    @dir = opts[:dir]
    @file = opts[:file]
    @changed_code = opts[:changes]
    @messages = examine_code
  end

  def errors?
    !@messages.empty?
  end

  def examine_code
    mess = []
    DEVELOPMENT_TEAM_INDICATORS.each do |re|
      if @changed_code.match(re)
        mess << %{Probable development team change "#{$1 || $&}" in #{@file}}
      end
    end
    mess
  end

  private

  DEVELOPMENT_TEAM_INDICATORS = [
    /DevelopmentTeam = /,
    /DEVELOPMENT_TEAM = /
  ]
end
