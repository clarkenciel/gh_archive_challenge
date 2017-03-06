module GHRepo

  ##
  # Printer and its subclasses are loosely based on
  # RSpec's formatter classes. I've found those be
  # nice and flexible.
  class Printer
    extend Registrar

    def initialize(output=nil)
      @output = output || StringIO.new
    end

    def start(signal)
      @output.puts
      @output.puts
    end

    def stop(signal)
      @output.puts
      @output.flush
    end

    def entry(signal)
    end

    def self.tag(name)
      Printer.register(name, self)
    end
  end
end
