#!/usr/bin/env ruby

opts = GHRepo::OptParser.parse(ARGV)
GHRepo::Runner.new(
  after: opts.after,
  before: opts.before,
  event: opts.event,
  count: opts.count,
  formatter: opts.formatter
).run
