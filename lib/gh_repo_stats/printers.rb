module GHRepo
  %w(printer base).each { |fn| require "./printers/#{fn}" }
end
