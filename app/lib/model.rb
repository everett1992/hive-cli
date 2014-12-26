require 'lib/store'

module App
  class Model
    def initialize obj={}
      raise ArgumentError.new('arg 1 must be Hash') unless obj.is_a? Hash

      sym_obj = {}
      obj.each { |key, val| sym_obj[key.to_sym] = val }
      @obj = sym_obj
    end

    def self.add obj
      model = self.new(obj)
      self.store.add(self.to_s, model)
    end

    def self.find id
      self.store.find(self, id)
    end

    private

    def self.has_field *attrs
      attrs.each do |a|
        attr = a.to_sym
        define_method attr do
          @obj[attr]
        end

        define_method :"#{attr}=" do |val|
          @obj[attr] = val
        end
      end
    end

    def self.has_one *attrs
      attrs.each do |a|
        attr = a.to_s
        attr_id = :"#{attr}_id"

        has_field attr_id

        define_method attr do
          self.class.store.find(attr, @obj[attr_id])
        end
      end
    end

    def self.store(store=@@store)
      @@store = store
    end

    has_field :id
  end

end
