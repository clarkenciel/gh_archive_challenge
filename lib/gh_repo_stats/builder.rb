module GHRepo
  %w(concerns builder).each { |fn| require_relative "./builder/#{fn}" }
end
