require 'lib/model'

class Hive::QueuedEpisode < Hive::Model
  has_one :episode
  has_field :idx

  def title
    episode.title
  end
end

