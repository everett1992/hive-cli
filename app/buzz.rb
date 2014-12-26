require 'lib/store'

require 'net/http'
require 'json'
require 'irb'

module Hive

  # Wrapper around buzz API
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

      Hive::STORE.add_json res.body
    end
  end
end
