module GHRepo
  %w(sink 
    source 
    reduce
    transform
    async_transform 
    pipe
    filter 
    time_source 
    flatmap_transform).
    each { |fn| require_relative "./streams/#{fn}" }
end
