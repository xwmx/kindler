Gem::Specification.new do |s|
  s.name     = 'kindler'
  s.version  = '0.1.4'
  s.date     = '2009-11-29'
  s.summary  = 'Ruby Kindle library'
  s.description = <<-EOS
    KindleR is a library for packaging and formatting MOBI files.
  EOS

  s.files = Dir['lib/**/*.rb']
  s.executables = ['kindler', 'kindler-dropbox', 'kindler-rename']

  s.has_rdoc = false
  s.extra_rdoc_files = %w[README.rdoc LICENSE]

  s.author   = 'Joshua Peek'
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/kindler'
end
