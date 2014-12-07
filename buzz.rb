require_relative 'config.rb'
require 'net/http'
require 'json'
require 'irb'

module Hive
  class Buzz
    def self.queued_episodes
      request('queued_episodes')['queued_episodes']
        .map(&:episode)
    end

    def self.suggestions(type)
      request('episodes', suggestions: type)['episodes']
    end

    def self.request resource, params={}
      path = [Config::Buzz.root, resource].join('/')
      params = { user_id_hash: Config::Buzz.id_hash }.merge(params)
      url = URI::HTTP.build({
        host: Config::Buzz.host,
        path: path,
        query: URI.encode_www_form(params)
      })

      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }

      store res.body
    end

    private

    def self.store response
      JSON.parse(response)
        .map    { |key, records| [Inflections.to_class(key), key, records] }
        .reject { |klass, _, _| klass.nil? }
        .map    { |klass, key, records| [ key, records.map { |r|  klass.add(r) }] }
        .to_h
    end
  end

  STORE = Hash.new

  class Model

    def initialize obj
      @obj = obj
    end

    def self.add obj
      model = self.new(obj)
      store[obj['id']] = model
    end

    def self.find id
      store[id]
    end

    private

    def self.has_field *attrs
      attrs.each do |a|
        attr = a.to_s
        define_method attr do
          @obj[attr]
        end
      end
    end

    def self.has_one *attrs
      attrs.each do |a|
        attr = a.to_s
        define_method attr do
          klass = Inflections.to_class(attr)
          klass.find @obj["#{attr}_id"]
        end
      end
    end

    def self.store
      STORE[self] ||={}
    end

    has_field :id
  end

  class Episode < Model
    has_one :podcast
    has_field :title, :audio_url, :duration, :ed_is_played, :ed_current_position
  end

  class Podcast < Model
    has_field :title
  end

  class QueuedEpisode < Model
    has_one :episode
    has_field :idx

    def title
      episode.title
    end
  end

  class Inflections
    inflections = [
      ['episode', 'episodes'],
      ['podcast', 'podcasts'],
      ['queued_episode', 'queued_episodes'],
    ]

    @@singleMap = inflections.to_h
    @@pluralMap = @@singleMap.invert

    def self.to_single word
      @@pluralMap[word] || word
    end

    def self.to_plural word
      @@singleMap[word] || word
    end

    def self.camel_case string
      return string if string !~ /_/ && string =~ /[A-Z]+.*/
      string.split('_').map{|e| e.capitalize}.join
    end

    def self.to_class string
      Object.const_get('Hive::'+camel_case(to_single(string))) rescue nil
    end
  end
end
