require 'json'
module App

  # Collects instances of model objects.
  class Store
    def initialize inflections=Inflections.new
      @inflections = inflections
      @store = Hash.new
    end

    def add_json(response)
      JSON.parse(response)
        .map    { |key, records| [@inflections.to_class(key), key, records] }
        .reject { |klass, _, _| klass.nil? }
        .map    { |klass, key, records| [ key, records.map { |r|  klass.add(r) }] }
        .to_h
    end

    def namespace
      @inflections.namespace
    end

    def klass_store(klass)
      @store[@inflections.to_class(klass)] ||={}
    end

    def find(klass, id)
      klass_store(klass)[id]
    end

    def add(klass, model)
      klass_store(klass)[model.id] = model
    end
  end
end
