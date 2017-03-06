module GHRepo
  ##
  # Mixin that provides a DSL for objects that
  # can be built using a builder pattern.
  #
  # This is used to make it easy to declare
  # objects corresponding to the payloads sent by the
  # github archive.
  #
  # We don't care about a lot of the data, and many of
  # the keys have been changed over the lifetime of the service
  # this DSL provides a simple way to enumerate the keys we care about
  # and to provide aliases and pre-processors on those keys.
  module Builder
    def self.included(mod)
      mod.extend(DSL)
    end

    def concerns
      self.class.concerns
    end

    def options
      concerns.keys
    end

    def build(hash)
      concerns.build_on(self, hash)
    end

    module DSL
      def inherited(sub)
        sub.builds_like(self)
      end

      def builds_like(otherklass)
        otherklass.concerns.duplicate_on(self)
      end

      ##
      # Example:
      #   attribute(:dogs, aliases: [:doggos, :pupsters]) do |dog|
      #     dog.rate(13, 10)
      #   end
      def attribute(name, aliases: nil, &block)
        concerns.add(name, block)
        attr_accessor(name)
        unless aliases.nil?
          concerns.add_aliases(name, aliases)
          aliases.each do |a|
            attr_accessor(a)
            alias_method a, name
            alias_method "#{a}=".to_sym, "#{name}=".to_sym
          end
        end
      end

      ##
      # Example:
      #   attributes(
      #     :cats, :mice,
      #     birds: ->(bird) { Cage.fill(bird) }
      #   )
      def attributes(*names, **name_block_pairs)
        names.each { |n| attribute(n) }
        name_block_pairs.each { |n, b| attribute(n, &b) }
      end

      def concerns
        @cs ||= Concerns.new
      end
    end
  end
end
