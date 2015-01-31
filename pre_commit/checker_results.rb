class CheckerResults

  def initialize
    @checkers = []
  end
  
  def record(checker)
    @checkers << checker
  end

  def errors?
    @checkers.map(&:errors?).any?
  end

  def checkers
    @checkers
  end

  def to_s
    out = "";
    @checkers.each do |checker|
      if checker.errors?
        checker.messages.each do |message|
          out += (message)
          out += "\n"
        end
        if checker.class.respond_to?(:deactivation_message)
          out += checker.class.method(:deactivation_message).call
          out += "\n"
        end
      end
    end
    out
  end
end
