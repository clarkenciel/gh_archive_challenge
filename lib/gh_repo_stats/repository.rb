module GHRepo

  ##
  # Repositories are simply builders.
  # I haven't needed variations on this, but I may :).
  #
  # It also uses value equality and simpler hashing
  # so that they can be used more intuitively as keys
  # in hashes
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
end
