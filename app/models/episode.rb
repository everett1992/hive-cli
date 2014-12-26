require 'lib/model'
class Hive::Episode < Hive::Model
  has_one :podcast
  has_field :title, :audio_url, :duration, :ed_is_played, :ed_current_position

  def file
    AudioFile.new self
  end
end
