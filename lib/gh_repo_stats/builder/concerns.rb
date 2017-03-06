module GHRepo

  ##
  # Hash-esque object for storing the concerns of a builder
  # includer.
  class Concerns
    def initialize
      @cs = {}
    end

    def add(name, block)
      @cs[name] = { aliases: Set.new, block: block }
    end

    def keys
      @cs.keys
    end

    def each(&b)
      return @cs.each unless block_given?
      @cs.each(&b)
    end

    def add_aliases(target, aliases)
      cs_as = @cs[target][:aliases]
      @cs[target][:aliases] = cs_as.union(aliases)
    end

    def duplicate_on(other_klass)
      @cs.each do |name, p|
        aliases, block = p.values_at(:aliases, :block)
        if aliases.empty?
          other_klass.attribute(name, &block)
        else
          other_klass.attribute(name, aliases: aliases, &block)
        end
      end
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
        key, data = pair
        block, aliases = data.values_at(:block, :aliases)
        key = aliases.empty? ? key : aliases.union([key]).find { |a| hash.has_key?(a) }

        if block.nil?
          object.send("#{key}=".to_sym, hash[key])
        else
          object.send("#{key}=".to_sym, block.call(hash[key]))
        end
        object
      end
    end
  end
end
