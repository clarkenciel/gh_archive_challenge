require './lib/version'

Gem::Specification.new do |s|
  s.name = 'gh_archive_challenge'
  s.version = GHRepo.version
  s.authors = ['Danny Clarke']
  s.email = ['clarkenciel@gmail.com']
  s.files = Dir['Gemfile', 'gh_archive_challenge.gemspec', 'lib/**/*.rb', 'bin/gh_repo_stats']
  s.executables = %w(gh_repo_states)
end
