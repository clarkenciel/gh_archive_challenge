module GHRepo
  %w(event events).each { |fn| require "./events/#{fn}" }
end
