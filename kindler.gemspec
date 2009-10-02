Gem::Specification.new do |s|
  s.name     = 'kindler'
  s.version  = '0.1.2'
  s.date     = '2009-09-06'
  s.summary  = 'Ruby Kindle library'
  s.description = <<-EOS
    KindleR is a library for packaging and formatting MOBI files.
  EOS
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/kindler'
  s.has_rdoc = false
  s.authors  = ["Joshua Peek"]
  s.files    = [
    "lib/mobi.rb",
    "lib/mobi/extended_header.rb",
    "lib/mobi/header.rb"
  ]
  s.executables = ['kindler', 'kindler-dropbox', 'kindler-rename']
  s.extra_rdoc_files = %w[README.rdoc MIT-LICENSE]
  s.add_dependency 'palm', '>= 0.0.4'
end
