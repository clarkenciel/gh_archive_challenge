module GHRepo
  %w(event events).each { |fn| require_relative "events/#{fn}" }
end
