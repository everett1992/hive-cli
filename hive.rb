require 'ruby-mpd'
require 'thor'
require 'irb'
require_relative 'config.rb'
require_relative 'buzz.rb'

if Hive::Config::Buzz.id_hash.nil?
  puts "Environment variable BUZZ_USER_ID undefined, exiting"
  exit 1
end

episodes = {
  queued_episodes:  Hive::Buzz.queued_episodes,
  news:  Hive::Buzz.suggestions('News'),
  serial:  Hive::Buzz.suggestions('Serial'),
  normal:  Hive::Buzz.suggestions('Normal')
}

episodes.each do |t, ep|
  puts t
  ep.each_with_index do |episode, i|
    puts "#{i+1}: #{episode.title}"
  end
  puts
end

episodes['queued_episodes']
