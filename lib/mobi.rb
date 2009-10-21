require 'palm/pdb'

class Hash
  # 1.8 does not have Hash#key
  alias_method :key, :index unless method_defined?(:key)
end

class Mobi < Palm::PDB
  autoload :ExtendedHeader, 'mobi/extended_header'
  autoload :Header, 'mobi/header'

  # Optimized version of Mobi#title= that does not parse the
  # entire document.
  def self.rename(pdb, name)
    header = pdb.data[0].data

    offset = header.unpack('@84N')[0]
    length = header.unpack('@88N')[0]
    header[offset...offset+length] = ("\000" * length)

    header[88...88+4] = [name.length].pack('N*')
    header[offset...offset+name.length] = name

    pdb.name = name

    pdb
  end

  def initialize(from = nil)
    super

    self.creator = 'MOBI'
    self.type = 'BOOK'
    self.data[0] ||= Header.new
  end

  def header
    data[0]
  end

  def title
    header.full_name
  end

  def title=(title)
    header.full_name = title
    self.name = title
  end

  def content
    text = ''
    header.record_count.times do |n|
      text << data[n + 1].data
    end
    text
  end

  def content=(text)
    header.text_length = text.length
    record_size = header.record_size
    io = StringIO.new(text)
    index = 1

    while str = io.read(record_size)
      record = Palm::RawRecord.new(str)
      record.record_id = index
      index += 1
      data << record
    end

    header.record_count = index

    nil
  end

  protected
    def unpack_entry(byte_string)
      header = byte_string.unpack('@16a4') == ['MOBI'] rescue false
      header ? Header.from_binary(byte_string) :
        Palm::RawRecord.new(byte_string)
    end

    def unpack_header(header)
      super
    end

    def pack_header(app_info_offset, sort_offset)
      super
    end

    def pack_entry(entry)
      entry.data
    end
end
