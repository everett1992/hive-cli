module App
  # Suite of string metaprogramming manipulations in the spirit of ActiveSupport
  # but terrible

  class Inflections
    attr_accessor :namespace

    def initialize dict: dict={}, namespace: namespace
      self.dictionary = dict
      @namespace = namespace
    end

    def dictionary= dict={}
      @single_map = dict
      @plural_map = dict.invert
    end

    def dictionary
      @single_map.keys
    end
    def to_single word
      @plural_map[word] || word
    end

    def to_plural word
      @single_map[word] || word
    end

    def camel_case string
      return string if string !~ /_/ && string =~ /[A-Z]+.*/
      string.split('_').map{|e| e.capitalize}.join
    end

    def to_class string

      name = [camel_case(to_single(string))]
      name.unshift(@namespace) if @namespace

      Object.const_get(name.join('::')) rescue nil
    end
  end
end

