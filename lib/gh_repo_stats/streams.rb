module GHRepo
  %w(sink source transform async_transform filter time_source).
    each { |fn| require_relative "./streams/#{fn}" }
end
