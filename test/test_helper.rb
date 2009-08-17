require 'test/unit'
require 'mobi'

class Test::Unit::TestCase
  def fixture(name)
    File.join(File.dirname(__FILE__), 'fixtures', "#{name}.mobi")
  end
end
