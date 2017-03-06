module GHRepo
  %w(printer basic).each { |fn| require_relative "printers/#{fn}" }
end
