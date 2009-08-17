require 'rake/packagetask'
require 'rake/gempackagetask'

# load gemspec like github's gem builder to surface any SAFE issues.
Thread.new {
  require 'rubygems/specification'
  $spec = eval("$SAFE=3\n#{File.read('kindler.gemspec')}")
}.join
 
Rake::GemPackageTask.new($spec) do |package|
  package.gem_spec = $spec
end

require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
end
