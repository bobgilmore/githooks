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
    preamble_displayed = false
    out = "";
    @checkers.each do |checker|
      if checker.errors?
        out += "ERROR: git pre-commit hook found the following problems...\n\n" unless preamble_displayed
        preamble_displayed = true
        checker.messages.each do |message|
          out += "#{message}\n"
        end
        if checker.class.respond_to?(:deactivation_message)
          out += "#{checker.class.method(:deactivation_message).call}"
        end
        out += "--------------\n"
      end
    end
    out
  end
end
