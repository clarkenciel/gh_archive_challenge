require 'open-uri'
require 'net/https'
require 'json'
require 'zlib'
require 'optparse'
require 'optparse/time'


module GHRepo
  %w(builder registrar streams events repository printers runner cli).each do |fn|
    require_relative "./gh_repo_stats/#{fn}"
  end
end
