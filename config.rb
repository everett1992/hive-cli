module Hive
  module Config

    class Mpd
      def self.host
        'localhost'
      end

      def self.port
        '6601'
      end

      def podcast_directory
        '~/Music/podcasts'
      end
    end

    class Buzz
      def self.id_hash
        ENV["BUZZ_USER_ID"]
      end

      def self.host
        'www.buzzradio.xyz'
      end

      def self.root
        '/api/v1'
      end
    end
  end
end
