module GHRepo
  %w(sink source transform async_transform filter).each { |fn| require_relative "./streams/#{fn}" }
end
