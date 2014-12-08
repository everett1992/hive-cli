module Hive

  # Collects instances of model objects.
  class Store
    def initialize
      @store = Hash.new
    end
    def add_json(response)
      JSON.parse(response)
        .map    { |key, records| [Inflections.to_class(key), key, records] }
        .reject { |klass, _, _| klass.nil? }
        .map    { |klass, key, records| [ key, records.map { |r|  klass.add(r) }] }
        .to_h
    end

    def klass_store(klass)
      @store[klass] ||={}
    end

    def find(klass, id)
      klass_store(klass)[id]
    end

    def add(klass, model)
      klass_store(klass)[model.id] = model
    end
  end

  STORE = Store.new
end
