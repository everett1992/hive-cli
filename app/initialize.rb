# Add application directories to the load path.
# I'm making this up as I go along.
$:.unshift __dir__

require 'config'
require 'lib/inflections'
require 'lib/store'
require 'lib/model'

module Hive

  Inflections = App::Inflections.new

  Inflections.namespace = Hive

  Inflections.dictionary = {
      'episode' => 'episodes',
      'podcast' => 'podcasts',
      'queued_episode' => 'queued_episodes',
  }

  STORE = App::Store.new Inflections

  class Model < App::Model
    store STORE
  end

end

# Load all models
Dir[File.join(__dir__, 'models', '*.rb')].each { |f| require f }
