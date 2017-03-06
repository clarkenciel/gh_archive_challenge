module GHRepo
  class API
    class << self
      ARCHIVE_ROOT = 'http://data.githubarchive.org/%s.json.gz'.freeze

      def events_at(time)
        file = query_time(time)
        parse_contents(Zlib::GzipReader.new(file).read) if file
      end

      def format_time(time)
        time.strftime('%Y-%m-%d-%H')
      end

      def query_time(time)
        url = ARCHIVE_ROOT % format_time(time)
        StringIO.new(open(url).read) # avoid having too many open file handles
      rescue OpenURI::HTTPError => e
        STDERR.puts "ERROR @ #{url}: #{e.message}"
      end

      def parse_contents(contents)
        contents.split("\n").map do |o|
          hash = JSON.parse(o, symbolize_names: true)
          Event.find(hash[:type]).from_hash(hash)
        end
      end
    end
  end
end
