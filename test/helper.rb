require 'test/unit'
require 'mobi'

class Test::Unit::TestCase
  def fixture(name)
    if block_given?
      begin
        f = Tempfile.new(name)
        f << File.read(fixture(name))
        f.flush
        yield f.path
      ensure
        f.unlink
      end
    else
      File.join(File.dirname(__FILE__), 'fixtures', "#{name}.mobi")
    end
  end
end
