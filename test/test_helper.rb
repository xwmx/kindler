$: << File.join(File.dirname(__FILE__), '..', 'lib')

require 'rubygems'
require 'mobi'

require 'test/unit'

class Test::Unit::TestCase
  FIXTURES = File.join(File.dirname(__FILE__), 'fixtures')

  def fixture(name)
    File.join(FIXTURES, "#{name}.mobi")
  end
end
