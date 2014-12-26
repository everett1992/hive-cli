require 'test_helper.rb'

# I know that this test is pretty useless,
# but tests have to start somewhere.

describe App::Inflections do

  subject do
    App::Inflections.new(dict: {
      'foo' => 'foos',
      'bar' => 'bars',
    })
  end

  ##
  # Limited single case transformation works for a small set of defined
  # words
  describe 'it signleizes' do

    it '"fofoo"foo"' do
      subject.to_single('foos').must_equal 'foo'
    end

    it '"foo" to itself' do
      subject.to_single('foo').must_equal 'foo'
    end

    it 'unknown words to themselves' do
      subject.to_single('rats').must_equal 'rats'
    end
  end

  ##
  # Limited pluralization
  describe 'it pluralizes' do

    it '"bar" to "bars"' do
      subject.to_plural('bar').must_equal 'bars'
    end

    it '"bars" to itself' do
      subject.to_plural('bars').must_equal 'bars'
    end

    it 'unknown words to themselves' do
      subject.to_plural('rat').must_equal 'rat'
    end
  end

  ##
  # Camelcasing works by spliting words on underscores then joining
  # the capitolized words.
  describe 'it camel cases ' do
    it '"test_string_ok" to "TestStringOk"' do
      subject.camel_case('test_string_ok').must_equal 'TestStringOk'
    end

    it '"test_string_123" to "TestString123"' do
      subject.camel_case('test_string_123').must_equal 'TestString123'
    end

    it '"TEST_STRING" to "TESTSTRING"' do
      subject.camel_case('TEST_STRING').must_equal 'TestString'
    end
  end
end
