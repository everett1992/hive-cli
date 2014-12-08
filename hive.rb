require 'ruby-mpd'
require 'thor'
require 'irb'
require_relative 'config.rb'
require_relative 'buzz.rb'

module Hive
  class AudioFile
    def initialize episode
      @episode = episode
      @filename = self.class.filename @episode
    end

    def download episode
    end

    def remove episode
      File.delete(@filename) if exists?
    end


    def exists?
      File.exists?(@filename)
    end

    # An array of all files in the podcast directory
    def self.all
      Dir[File.join(Config::Mpd.podcast_directory, '**', '*')]
        .select { |f| File.file? f }
    end

    # Remove all files (except the ones passed in the `keep` parameter)
    #   keep is an array of filenames.
    def self.clean(keep)
      File.delete(*(all - keep))
    end

    # Map an episode to a file name.
    def self.filename episode
      File.join(Config::Mpd.podcast_directory,
                episode.podcast.title,
                episode.publication_date,
                episode.title)
    end
  end
end

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
