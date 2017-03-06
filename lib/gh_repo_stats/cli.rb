module GHRepo
  Options = Struct.new(:after, :before, :event, :count, :formatter)

  class OptParser
    def self.parse(options)
      args = Options.new

      opt_parser = OptionParser.new

      opt_parser.accept(Event) do |event_name|
        Event.find(event_name)
      end

      opt_parser.accept(Printer) do |p_name|
        Printer.find(p_name)
      end

      opt_parser.on('-a', '--after TIME', Time, 'Start of date range to look within') do |after|
        args.after = after
      end

      opt_parser.on('-b', '--before TIME', Time, 'End of date range to look within') do |before|
        args.before = before
      end


      opt_parser.on('-n', '--count COUNT', Integer, 'Number of events to retrieve') do |count|
        args.count = count
      end

      opt_parser.on('-f', '--format FORMAT', Printer, 'Output format') do |formatter|
        args.formatter = formatter
      end

      opt_parser.on('-h', '--help', 'Prints this help') do
        puts opt_parser
        exit
      end

      opt_parser.on('-e', '--event EVENT_NAME', Event, "Event type to look for:\n #{Event.options.join(', ')}") do |event|
        args.event = event
      end


      safe_parse(opt_parser, options, args)
    end

    def self.safe_parse(opt_parser, options, args)
      opt_parser.parse!(options)
      required = [:after, :before, :event, :count]
      begin
        missing = required.select { |a| args[a].nil? }
        raise(OptionParser::MissingArgument, missing.join(', ')) unless missing.empty?
        args
      rescue OptionParser::MissingArgument, OptionParser::InvalidOption
        puts $!.to_s
        puts opt_parser
        exit
      end
    end
  end
end
