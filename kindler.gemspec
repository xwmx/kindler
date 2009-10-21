Gem::Specification.new do |s|
  s.name     = 'kindler'
  s.version  = '0.1.3'
  s.date     = '2009-10-21'
  s.summary  = 'Ruby Kindle library'
  s.description = <<-EOS
    KindleR is a library for packaging and formatting MOBI files.
  EOS
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/kindler'
  s.has_rdoc = false
  s.authors  = ['Joshua Peek']
  s.files    = [
    'lib/mobi/extended_header.rb',
    'lib/mobi/header.rb',
    'lib/mobi.rb',
    'lib/palm/palm_record.rb',
    'lib/palm/palm_support.rb',
    'lib/palm/pdb.rb',
    'lib/palm/raw_record.rb'
  ]
  s.executables = ['kindler', 'kindler-dropbox', 'kindler-rename']
  s.extra_rdoc_files = %w[README.rdoc LICENSE]
end
