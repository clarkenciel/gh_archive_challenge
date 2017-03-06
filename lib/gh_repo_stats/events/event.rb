module GHRepo

  ##
  # Events are builders and the Event class provides
  # a registry of all of the events available.
  #
  # New Events can be added as subclasses of Event
  # that +tag+ themselves.
  # 
  # Subclasses can take advantage of the Builder
  # DSL to add their own concerns/specific aliases
  class Event
    extend Registrar
    include Builder

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
end
