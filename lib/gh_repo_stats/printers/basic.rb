module GHRepo
  class BasicPrinter < Printer
    tag('basic')

    def entry(signal)
      @output.puts("%s/%s - %s events" % [
        signal[:repo][:owner], 
        signal[:repo][:name], 
        signal[:repo][:event_count]
      ])
    end
  end
end
