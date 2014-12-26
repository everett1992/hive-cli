require_relative '../app/initialize.rb'

class Minitest::Test
  # Change the displayed format of test names.
  def location
    loc = " [#{self.failure.location}]" unless passed? or error?
    test_class = self.class.to_s.gsub "::", ": "
    test_name = self.name.to_s.gsub(/\Atest_\d{4,}_/, "")
    "#{test_class} #{test_name}#{loc}"
  end

end
