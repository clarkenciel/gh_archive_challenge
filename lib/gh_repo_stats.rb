require 'open-uri'
require 'net/https'
require 'json'
require 'zlib'
require 'optparse'
require 'optparse/time'
require 'byebug'


module GHRepo
  # --- Mixins

  ##
  # This is a pattern I first saw in Jneen Adkisson's [Rouge](https://github.com/jneen/rouge)
  # syntax highlighting tool. The idea is that this should be extended by some
  # top-level class that defines a class method which it's children can call to register
  # themselves (I use tag here). That way the top level class can be configured to use
  # inputs that might be more human readable, i.e. the names of things presented to users
  # are less explicitly coupled to the names of the corresponding objects used by the program.
  #
  # Extenders should provide their own function for subclass registration that
  # calls this module's +register+ method.
  #
  # Extenders should also considering overwriting the +reformat+ method.
  module Registrar
    def find(name)
      registry[reformat(name)]
    end

    def registry
      @reg ||= {}
    end

    def register(name, val)
      registry[name] = val
    end

    def options
      registry.keys
    end

    def reformat(name)
      name
    end
  end

  class Concerns
    def initialize
      @cs = {}
    end

    def add(name, block)
      @cs[name] = block
    end

    def each(&b)
      return @cs.each unless block_given?
      @cs.each(&b)
    end

    ##
    # Accepts a target object and an arbitrary hash.
    #
    # Will iterate through each of the stored concerns
    # and attempt to populate attributes on the target object
    # using +attr=+ methods.
    #
    # For each concern, if it is paired with a block, the block
    # will be called on the value stored in the corresponding hash.
    # Otherwise, the hash's value will be used unaltered.
    def build_on(object, hash)
      @cs.reduce(object) do |obj, pair|
        key, block = pair
        if block.nil?
          object.send("#{key}=".to_sym, hash[key])
        else
          object.send("#{key}=".to_sym, block.call(hash[key]))
        end
        object
      end
    end
  end

  module Builder
    def self.included(mod)
      mod.extend(DSL)
    end

    def concerns
      self.class.concerns
    end

    def build(hash)
      concerns.build_on(self, hash)
    end

    module DSL
      def inherited(sub)
        concerns.each do |name, p|
          sub.attribute(name, &p)
        end
      end

      def attribute(name, aliases: nil, &block)
        concerns.add(name, block)
        attr_accessor(name)
        unless aliases.nil?
          aliases.each do |a|
            attr_accessor(a)
            alias_method a, name
            alias_method "#{a}=".to_sym, "#{name}=".to_sym
          end
        end
      end

      def attributes(*names, **name_block_pairs)
        names.each { |n| attribute(n) }
        name_block_pairs.each { |n, b| attribute(n, &b) }
      end

      def concerns
        @cs ||= Concerns.new
      end
    end
  end

  # --- Event types
  class Event
    extend Registrar
    include Builder

    attribute(:repository, aliases: [:repo]) do |rep|
      Repository.from_hash(rep) if rep
    end

    def initialize(hash)
      build(hash)
    end

    class << self
      def tag(name)
        Event.register(name, self)
      end

      def from_hash(hash)
        new(hash)
      end

      ##
      # e.g. CommitCommentEvent -> commit-comment
      def reformat(name)
        name.gsub(/(\w)([A-Z])/, '\1-\2').downcase.gsub(/-event$/, '')
      end
    end
  end

  class PushEvent < Event
    tag('push')
  end

  class CommitCommentEvent < Event
    tag('commit-comment')
  end

  class CreateEvent < Event
    tag('create')
  end

  class DeleteEvent < Event
    tag('delete')
  end

  class DeploymentEvent < Event
    tag('deployment')
  end

  class DownloadEvent < Event
    tag('download')
  end

  class DeploymentStatusEvent < Event
    tag(reformat('DeploymentStatusEvent'))
  end

  class FollowEvent < Event
    tag(reformat('FollowEvent'))
  end

  class ForkEvent < Event
    tag(reformat('ForkEvent'))
  end

  class ForkApplyEvent < Event
    tag(reformat('ForkApplyEvent'))
  end

  class GistEvent < Event
    tag(reformat('GistEvent'))
  end

  class GollumEvent < Event
    tag(reformat('GollumEvent'))
  end

  class IssueCommentEvent < Event
    tag(reformat('IssueCommentEvent'))
  end

  class IssuesEvent < Event
    tag(reformat('IssuesEvent'))
  end

  class LabelEvent < Event
    tag(reformat('LabelEvent'))
  end

  class MemberEvent < Event
    tag(reformat('MemberEvent'))
  end

  class MembershipEvent < Event
    tag(reformat('MembershipEvent'))
  end

  class MilestoneEvent < Event
    tag(reformat('MilestoneEvent'))
  end

  class OrganizationEvent < Event
    tag(reformat('OrganizationEvent'))
  end

  class OrgBlockEvent < Event
    tag(reformat('OrgBlockEvent'))
  end

  class PageBuildEvent < Event
    tag(reformat('PageBuildEvent'))
  end

  class ProjectCardEvent < Event
    tag(reformat('ProjectCardEvent'))
  end

  class ProjectColumnEvent < Event
    tag(reformat('ProjectColumnEvent'))
  end

  class ProjectEvent < Event
    tag(reformat('ProjectEvent'))
  end

  class PublicEvent < Event
    tag(reformat('PublicEvent'))
  end

  class PullRequestEvent < Event
    tag(reformat('PullRequestEvent'))
  end

  class PullRequestReviewEvent < Event
    tag(reformat('PullRequestReviewEvent'))
  end

  class PullRequestReviewCommentEvent < Event
    tag(reformat('PullRequestReviewCommentEvent'))
  end

  class ReleaseEvent < Event
    tag(reformat('ReleaseEvent'))
  end

  class RepositoryEvent < Event
    tag(reformat('RepositoryEvent'))
  end

  class StatusEvent < Event
    tag(reformat('StatusEvent'))
  end

  class TeamEvent < Event
    tag(reformat('TeamEvent'))
  end

  class TeamAddEvent < Event
    tag(reformat('TeamAddEvent'))
  end

  class WatchEvent < Event
    tag(reformat('WatchEvent'))
  end

  # --- Repositories

  class Repository
    include Builder

    attributes(:id, :name, :event_count, :owner)
    def initialize(h); build(h); end

    def ==(other)
      other.id == @id
    end

    def <=>(other)
      @id <=> other.id
    end

    ##
    # Since these are basically transparent records, we want
    # identity and equality to be based on contents.
    def hash
      as_hash.hash
    end

    ##
    # Since these are basically transparent records, we want
    # identity and equality to be based on contents.
    def eql?(other)
      other.as_hash == as_hash
    end

    def as_hash
      concerns.each.reduce({}) do |h, attr|
        k, _ = attr
        h[k] = send(k)
        h
      end
    end

    def self.from_hash(h)
      new(h)
    end
  end

  # --- Query stuff

  ##
  # I should break out the streaming logic so it is easier to test here.
  class TimeRangedEventStream
    ARCHIVE_ROOT = 'http://data.githubarchive.org/%s.json.gz'.freeze

    def initialize(from, to, event_type)
      @from = from
      @to = to
      @event_type = event_type
      @rate = 3600 # one hour
    end

    def each
      return results unless block_given?
      results.each { |r| yield r }
    end

    private

    ##
    # Retrieve and parse contents from each resource in parallel.
    # This should REALLY use a queue or thread pool...
    def results
      time_stream.
        map { |t| fetch_and_retrieve(t) }.
        force.lazy.flat_map(&:value).reject(&:nil?).
        select { |e| e.is_a?(@event_type) }
    end

    def fetch_and_retrieve(t)
      Thread.new do
        begin
          f = retrieve_file(t)
          res = parse_contents(f) unless f.nil?
          print '.'
          res

          # handling errors for too many open sockets.
          # https://github.com/ruby/ruby/blob/ruby_2_3/lib/net/http.rb#L881
        rescue => e 
          STDERR.puts("WARNING: #{e.message}. Retrying for #{t}")
          sleep 1
          retry
        end
      end
    end

    def retrieve_file(t)
      file = query_time(t)
      Zlib::GzipReader.new(file).read if file
    end

    def parse_contents(contents)
      contents.split("\n").map do |o|
        hash = JSON.parse(o, symbolize_names: true)
        Event.find(hash[:type]).from_hash(hash)
      end.select { |e| e.is_a? @event_type }
    end

    def format_time(t)
      t.strftime('%Y-%m-%d-%H')
    end

    def query_time(t)
      url = ARCHIVE_ROOT % format_time(t)
      begin
        StringIO.new(open(url).read) # avoid having too many open file handles
      rescue OpenURI::HTTPError => e
        STDERR.puts "ERROR @ #{url}: #{e.message}"
      end
    end

    def time_stream
      [@rate].lazy.cycle.with_index.
        map { |step, i| @from + (step * i) }.
        take_while { |t2| t2 < @to }
    end
  end

  # --- Printers

  class Printer
    extend Registrar

    def initialize(output=nil)
      @output = output || StringIO.new
    end

    def start(signal)
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

  # --- Runner
  class Runner
    def initialize(after: nil, before: nil, event: nil, count: nil, formatter: nil)
      @after = after
      @before = before
      @event_type = event
      @count = count
      @formatter = (formatter || BasicPrinter).new(STDOUT)
    end

    def run
      @formatter.start({})

      counts = TimeRangedEventStream.new(@after, @before, @event_type).each.
        map { |event| event.repository }.
        reduce({}) do |counter, repo|
        if counter.include?(repo)
          counter[repo] += 1
        else
          counter[repo] = 1
        end
        counter
      end

      counts.lazy.
        sort { |c1, c2| c2[1] <=> c1[1] }.take(@count).
        map { |k, v| { owner: k.owner, name: k.name, event_count: v } }.
        each { |h| @formatter.entry({ repo: h }) }

      @formatter.stop({})
    end
  end

  # --- CLI
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

      opt_parser.on('-e', '--event EVENT_NAME', Event, 'Event type to look for') do |event|
        args.event = event
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

      opt_parser.parse!(options)
      args
    end
  end

end
