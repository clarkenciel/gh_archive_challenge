require_relative '../spec_helper.rb'

class Dog
  include GHRepo::Builder

  def initialize(hash)
    build(hash)
  end
end

class GreatDane < Dog
  attribute(:size, aliases: [:height]) do |s|
    s.to_s + ' ft.'
  end

  attributes(:pointy_ears, :floppy_chops)
end

class StBernard < Dog
  builds_like(GreatDane)
  attribute(:keg)
end
