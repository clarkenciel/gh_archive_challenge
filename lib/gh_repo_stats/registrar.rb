module GHRepo

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
end
