class Mobi
  class ExtendedHeader
    TYPES = {
      1 => "drm_server_id",
      2 => "drm_commerce_id",
      3 => "drm_ebookbase_book_id",
      100 => "author",
      101 => "publisher",
      102 => "imprint",
      103 => "description",
      104 => "isbn",
      105 => "subject",
      106 => "publishingdate",
      107 => "review",
      108 => "contributor",
      109 => "rights",
      110 => "subjectcode",
      111 => "type",
      112 => "source",
      113 => "asin",
      114 => "versionnumber",
      115 => "sample",
      116 => "startreading",
      118 => "price",
      119 => "currency",
      201 => "coveroffset",
      202 => "thumboffset",
      203 => "hasfakecover",
      401 => "clippinglimit",
      402 => "publisherlimit",
      404 => "ttsflag",
      501 => "cdecontenttype",
      502 => "lastupdatetime",
      503 => "updatedtitle",
      504 => "cdecontentkey"
    }

    def self.from_binary(data, offset, max = nil)
      type = data.unpack("@#{offset + 4}N")[0]
      length = data.unpack("@#{offset + 8}N")[0]
      raise RangeError if max && (offset - 256 + length) > max
      data = data.unpack("@#{offset + 12}C#{length - 8}")
      new(type, data)
    end

    def initialize(type = 0, data = [])
      @type, @data = type, data
    end

    def type
      TYPES[@type] || @type
    end
    attr_writer :type

    def length
      @data.length + 8
    end
    alias_method :size, :length

    def data
      if type.is_a?(String)
        @data.pack('C*').unpack('a*').join
      else
        @data.pack('C*').unpack('N*')
      end
    end
    attr_writer :data

    def to_a
      [@type, length] + @data.pack('C*').unpack('N*')
    end

    def to_s
      to_a.pack("N*")
    end
  end
end
