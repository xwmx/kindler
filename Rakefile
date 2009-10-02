begin
  require 'mg'
  MG.new('kindler.gemspec')
rescue LoadError
end


require 'rake/testtask'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.warning = true
end
