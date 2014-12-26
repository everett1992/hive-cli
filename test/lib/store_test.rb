require 'test_helper.rb'
require 'lib/store.rb'
require 'lib/model.rb'

describe App::Store do

  let(:json) { <<-JSON
      {
        "foos":
          [
            {"id": "1", "title": "test"},
            {"id": "2", "title": "test"}
          ],
        "bars":
          [
            {"id": "1", "foo_id": "1"}
          ]
      }
    JSON
  }

  module HiveTest end
  class HiveTest::Foo < App::Model
  end

  class HiveTest::Bar < App::Model
  end

  inflections = App::Inflections.new
  inflections.namespace = HiveTest
  inflections.dictionary = {
      'foo' => 'foos',
      'bar' => 'bars',
    }

  HiveTest::STORE = App::Store.new(inflections)

  subject do
    HiveTest::STORE
  end

  it 'adds json' do
    subject.add_json json
  end

  it 'returns parsed hash' do
    result = subject.add_json(json)
    result.must_be_instance_of Hash

    result['foos'].first.must_be_instance_of HiveTest::Foo
    result['bars'].first.must_be_instance_of HiveTest::Bar
  end

end
