class CheckerResults

  def initialize
    @checkers = []
  end
  
  def record_checker(checker)
    @checkers << checker
  end

  def errors?
    @checkers.map(&:errors?).any?
  end

  def checkers
    @checkers
  end

  def puts
    @checkers.each do |checker|
      if checker.errors?
        checker.messages.each { |message| puts(message) }
        puts(checker.class.method(:deactivation_message).call) if checker.class.respond_to?(:deactivation_message)
      end
    end
  end
end
