require 'test_helper.rb'
require './app/config.rb'

# I know that this test is pretty useless,
# but tests have to start somewhere.

describe Hive::Config do
  describe 'defines a Mpd object' do

    subject { Hive::Config::Mpd }

    it 'has a host' do
      subject.host.must_equal 'localhost'
    end

    it 'has a port' do
      subject.port.must_equal '6601'
    end

    it 'has a podcast_directory' do
      subject.podcast_directory.must_equal '~/Music/podcasts'
    end
  end

  describe 'defines a Buzz object' do

    subject { Hive::Config::Buzz }

    it 'has a id_hash' do
        subject.id_hash.must_equal ENV["BUZZ_USER_ID"]
    end

    it 'has a host' do
        subject.host.must_equal 'www.buzzradio.xyz'
    end

    it 'has a root' do
        subject.root.must_equal '/api/v1'
    end
  end
end
