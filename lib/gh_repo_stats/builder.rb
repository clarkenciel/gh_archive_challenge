module GHRepo
  %(concerns builder).each { |fn| require "./builder/#{fn}" }
end
