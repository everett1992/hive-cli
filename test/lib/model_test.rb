require 'test_helper.rb'
require 'lib/model.rb'

describe App::Model do
  class ModelTest < App::Model
    has_field :test_field
    has_one :model_test
  end

  let(:attrs) {
    {
      id: "1",
      test_field: "value",
      model_test_id: "2"
    }
  }

  subject do
    ModelTest.new attrs
  end

  describe 'it controls how it is initialized' do
    it 'must be initialized with a Hash' do
      assert_raises(ArgumentError) { ModelTest.new([]) }
    end
  end

  describe 'works with symbol and string based keys' do
    it '#test_field returns attr["test_field"]' do
      string_hash = {
        'id' => "1",
        'test_field' => "value",
        'model_test_id' => "2"
      }

      string_model = ModelTest.new string_hash

      message = 'Failed to map field to string key'

      assert string_model.test_field == string_hash['test_field'], message
    end

    it '#test_field returns attr[:test_field]' do

      symbol_hash = {
        id: "1",
        test_field: "value",
      }

      symbol_model = ModelTest.new symbol_hash

      message = 'Failed to map field to symbol key'

      assert symbol_model.test_field == symbol_hash[:test_field], message
    end
  end

  describe 'has_field "test_field"' do
    it 'defines test_field method' do
      subject.must_respond_to(:test_field)
      subject.test_field.must_be_same_as attrs[:test_field]
    end

    it 'defines test_field= method' do
      subject.must_respond_to(:test_field=)
      subject.test_field = "changed value"
      subject.test_field.must_equal "changed value"
    end

  end

end
