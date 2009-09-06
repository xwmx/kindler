class Mobi
  class Header < Palm::Record
    TYPES = {
      2 => 'BOOK',
      3 => 'PALMDOC',
      4 => 'AUDIO',
      257 => 'NEWS',
      258 => 'NEWS_FEED',
      259 => 'NEWS_MAGAZINE',
      513 => 'PICS',
      514 => 'WORD',
      515 => 'XLS',
      516 => 'PPT',
      517 => 'TEXT',
      518 => 'HTML'
    }

    ENCODING = {
      1252 => 'ISO-8859-1',
      65001 => 'UTF-8'
    }

    LANGUAGES = {
      'es'    => 0x000a,
      'sv'    => 0x001d,
      'sv-se' => 0x041d,
      'sv-fi' => 0x081d,
      'fi'    => 0x000b,
      'en'    => 0x0009,
      'en-au' => 0x0C09,
      'en-bz' => 0x2809,
      'en-ca' => 0x1009,
      'en-cb' => 0x2409,
      'en-ie' => 0x1809,
      'en-jm' => 0x2009,
      'en-nz' => 0x1409,
      'en-ph' => 0x3409,
      'en-za' => 0x1c09,
      'en-tt' => 0x2c09,
      'en-us' => 0x0409,
      'en-gb' => 0x0809,
      'en-zw' => 0x3009,
      'da'    => 0x0006,
      'da-dk' => 0x0406,
      'da'    => 0x0006,
      'da'    => 0x0006,
      'nl'    => 0x0013,
      'nl-be' => 0x0813,
      'nl-nl' => 0x0413,
      'fi'    => 0x000b,
      'fi-fi' => 0x040b,
      'fr'    => 0x000c,
      'fr-fr' => 0x040c,
      'de'    => 0x0007,
      'de-at' => 0x0c07,
      'de-de' => 0x0407,
      'de-lu' => 0x1007,
      'de-ch' => 0x0807,
      'no'    => 0x0014,
      'nb-no' => 0x0414,
      'nn-no' => 0x0814
    }

    NO_DRM = 0xffffffff

    DEFAULTS = {
      :compression => 1,
      :text_length => 0,
      :record_count => 1,
      :record_size => 4096,
      :encryption => 0,

      :identifier => 'MOBI',
      :length => 232,
      :type => 'BOOK',
      :encoding => 'ISO-8859-1',
      :generator_version => 4,

      :first_non_book_index => 2,
      :full_name_offset => 352,
      :full_name => 'untitled',

      :language => 'en-us',
      :format_version => 4,
      :image_record_index => 2,
      :extended_flags => 0x50,

      :drm_offset => NO_DRM,
      :drm_count => 0,
      :drm_size => 0,
      :drm_flags => 0,

      :exth_identifier => 'EXTH',
      :exth_length => 0,
      :exth_count => 0,
      :extended_headers => []
    }

    def self.from_binary(data)
      h = new

      h.compression  = data.unpack('n2')[0]
      h.text_length  = data.unpack('@4N')[0]
      h.record_count = data.unpack('@8n2')[0]
      h.record_size  = data.unpack('@10n2')[0]
      h.encryption   = data.unpack('@12n2')[0]

      h.identifier = data.unpack('@16a4')[0]
      h.length = data.unpack('@20N')[0]
      h.type = data.unpack('@24N')[0]
      h.encoding = data.unpack('@28N')[0]
      h.id = data.unpack('@32N')[0]
      h.generator_version = data.unpack('@36N')[0]

      h.first_non_book_index = data.unpack('@80N')[0]
      h.full_name_offset = data.unpack('@84N')[0]
      full_name_length = data.unpack('@88N')[0]
      h.full_name = data.unpack("@#{h.full_name_offset}a#{full_name_length}")[0]

      h.language = data.unpack('@92N')[0]
      h.format_version = data.unpack('@104N')[0]
      h.image_record_index = data.unpack('@108N')[0]
      h.extended_flags = data.unpack('@128N')[0]

      h.drm_offset = data.unpack('@168N')[0]
      h.drm_count = data.unpack('@172N')[0]
      h.drm_size = data.unpack('@174N')[0]
      h.drm_flags = data.unpack('@176N')[0]

      h.exth_identifier = data.unpack('@248a4')[0]
      h.exth_length = data.unpack('@252N')[0]
      h.exth_count = data.unpack('@256N')[0]

      h.extended_headers = []
      offset = 256
      h.exth_count.times do
        offset += h.extended_headers.last.length if h.extended_headers.last
        begin
          header = ExtendedHeader.from_binary(data, offset, h.exth_length)
        rescue Exception => e
          warn "Corrupted EXTH Header" if $DEBUG
          header = ExtendedHeader.new
        end
        h.extended_headers << header
      end

      h
    end

    def initialize
      super

      @type, @language, @encoding = nil

      @expunged = @dirty = @deleted = @private = false

      DEFAULTS.each do |attr, value|
        send("#{attr}=", value) unless send(attr)
      end

      @id ||= (rand() * 1_000_000_000).floor
    end

    attr_accessor :compression, :text_length, :record_count, :record_size, :encryption
    attr_accessor :identifier, :length, :id, :generator_version
    attr_accessor :first_non_book_index
    attr_accessor :full_name_offset, :full_name
    attr_accessor :format_version, :image_record_index, :extended_flags
    attr_accessor :drm_offset, :drm_count, :drm_size, :drm_flags
    attr_accessor :exth_identifier, :exth_length, :exth_count, :extended_headers
    alias_method :size, :length

    def compressed?
      compression != 1
    end

    def encrypted?
      encryption != 0
    end

    def type
      TYPES[@type]
    end

    def type=(type)
      @type = TYPES.index(type) || type
    end

    def encoding
      ENCODING[@encoding]
    end

    def encoding=(encoding)
      @encoding = ENCODING.index(encoding) || encoding
    end

    def language
      LANGUAGES.index(@language)
    end

    def language=(language)
      @language = LANGUAGES[language] || language
    end

    def full_name_length
      full_name.length
    end

    def to_s
      [
        repack_as_int([compression, 0], 'n2'),
        text_length,
        repack_as_int([record_count, record_size], 'n2'),
        repack_as_int([encryption, 0], 'n2'),
        repack_as_int([identifier], 'a4'),
        length,
        TYPES.index(type),
        ENCODING.index(encoding),
        id,
        generator_version,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        0xffffffff,
        first_non_book_index,
        full_name_offset,
        full_name_length,
        LANGUAGES[language],
        0, 0,
        format_version,
        image_record_index,
        0, 0, 0, 0,
        extended_flags,
        0, 0, 0, 0, 0, 0, 0, 0,
        drm_offset,
        drm_count,
        drm_size,
        drm_flags,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        repack_as_int([exth_identifier], 'a4'),
        exth_length,
        exth_count,
        extended_headers.map { |exth| exth.to_a }
      ].flatten.pack('N*')
    end
    alias_method :data, :to_s

    def to_a
      to_s.unpack('N*')
    end

    private
      def repack_as_int(ary, format)
        ary.pack(format).unpack('N')[0]
      end
  end
end
