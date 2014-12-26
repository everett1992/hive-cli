# vim:ft=ruby:

minitest_options = [
  #all_after_pass: true,
  all_on_start: true,
  bundler: true,
  rubygems: true,
  cli: '--pride'
]
guard :minitest, *minitest_options do
  watch(%r{^test/(.+?)_test\.rb$})
  watch(%r{^app/(.+?)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
end
