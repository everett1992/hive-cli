module Hive
  # Suite of string metaprogramming manipulations in the spirit of ActiveSupport
  # but terrible
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

