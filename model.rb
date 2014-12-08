require_relative 'store.rb'
module Hive

  # Base model class
  class Model
    def initialize obj
      @obj = obj
    end

    def self.add obj
      model = self.new(obj)
      STORE.add(self, model)
    end

    def self.find id
      STORE.find(self, id)
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
          STORE.find(klass, @obj["#{attr}_id"])
        end
      end
    end

    def self.store
      STORE.klass_store(self)
    end

    has_field :id
  end

  class Episode < Model
    has_one :podcast
    has_field :title, :audio_url, :duration, :ed_is_played, :ed_current_position

    def file
      AudioFile.new self
    end
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
end
