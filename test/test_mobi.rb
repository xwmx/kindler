require 'test_helper'
require 'tempfile'

class TestMobi < Test::Unit::TestCase
  def test_rename
    temp = Tempfile.new('hello')
    temp << File.read(fixture(:hello))
    temp.flush

    new_title = 'hello again'

    mobi = Palm::PDB.new(temp.path)
    Mobi.rename(mobi, new_title)
    mobi.write_file(temp.path)

    mobi = Mobi.new(temp.path)
    assert_equal new_title, mobi.name
    assert_equal new_title, mobi.title
    assert_equal new_title, mobi.header.full_name
  ensure
    temp.unlink
  end

  def test_default
    mobi = Mobi.new

    assert mobi.attributes
    assert mobi.backed_up_at
    assert mobi.created_at
    assert mobi.modified_at
    assert_equal 0, mobi.modnum
    assert_equal nil, mobi.name
    assert_equal 'BOOK', mobi.type
    assert_equal 0, mobi.unique_id_seed
    assert_equal 0, mobi.version
    assert_equal 'MOBI', mobi.creator

    assert_equal false, mobi.header.expunged
    assert_equal false, mobi.header.dirty
    assert_equal false, mobi.header.deleted
    assert_equal false, mobi.header.private
    assert_equal nil, mobi.header.archive
    assert_equal 0, mobi.header.record_id
    assert_equal 0, mobi.header.category

    assert_equal 1, mobi.header.compression
    assert_equal false, mobi.header.compressed?
    assert_equal 0, mobi.header.text_length
    assert_equal 1, mobi.header.record_count
    assert_equal 4096, mobi.header.record_size
    assert_equal false, mobi.header.encrypted?

    assert_equal 'MOBI', mobi.header.identifier
    assert_equal 232, mobi.header.size
    assert_equal 'BOOK', mobi.header.type
    assert_equal 'ISO-8859-1', mobi.header.encoding
    assert_not_nil mobi.header.id
    assert_equal 4, mobi.header.generator_version
    assert_equal 2, mobi.header.first_non_book_index
    assert_equal 352, mobi.header.full_name_offset
    assert_equal 8, mobi.header.full_name_length
    assert_equal 'untitled', mobi.header.full_name
    assert_equal 'en-us', mobi.header.language
    assert_equal 4, mobi.header.format_version
    assert_equal 2, mobi.header.image_record_index
    assert_equal 0x50, mobi.header.extended_flags
    assert_equal 0xffffffff, mobi.header.drm_offset
    assert_equal 0, mobi.header.drm_count
    assert_equal 0, mobi.header.drm_size
    assert_equal 0, mobi.header.drm_flags

    assert_equal 'EXTH', mobi.header.exth_identifier
    assert_equal 0, mobi.header.exth_length
    assert_equal 0, mobi.header.exth_count

    assert mobi.header.to_s
  end

  def test_set_title_and_content
    mobi = Mobi.new

    mobi.title = 'Hello, World!'
    assert_equal 'Hello, World!', mobi.name
    assert_equal 13, mobi.header.full_name_length

    mobi.content = 'Hey!'
    assert_equal 4, mobi.header.text_length
    assert_equal 2, mobi.header.record_count

    assert mobi.header.to_s
  end

  def test_large_content
    mobi = Mobi.new

    mobi.content = 'a' * 100_000
    assert_equal 100_000, mobi.header.text_length
    assert_equal 26, mobi.header.record_count

    assert mobi.header.to_s
  end

  def test_open_hello
    mobi = Mobi.new(fixture(:hello))

    assert mobi.attributes
    assert mobi.backed_up_at
    assert mobi.created_at
    assert mobi.modified_at
    assert_equal 0, mobi.modnum
    assert_equal 'hello', mobi.name
    assert_equal 'BOOK', mobi.type
    assert_equal 5, mobi.unique_id_seed
    assert_equal 0, mobi.version
    assert_equal 'MOBI', mobi.creator

    assert_equal 'hello', mobi.title
    assert_equal '<html><head><guide></guide></head><body>Hello, World! <mbp:pagebreak/></body></html>', mobi.content

    assert_equal false, mobi.header.expunged
    assert_equal false, mobi.header.dirty
    assert_equal false, mobi.header.deleted
    assert_equal false, mobi.header.private
    assert_equal nil, mobi.header.archive
    assert_equal 0, mobi.header.record_id
    assert_equal 0, mobi.header.category

    assert_equal 1, mobi.header.compression
    assert_equal false, mobi.header.compressed?
    assert_equal 84, mobi.header.text_length
    assert_equal 1, mobi.header.record_count
    assert_equal 4096, mobi.header.record_size
    assert_equal false, mobi.header.encrypted?

    assert_equal 'MOBI', mobi.header.identifier
    assert_equal 232, mobi.header.size
    assert_equal 'BOOK', mobi.header.type
    assert_equal 'ISO-8859-1', mobi.header.encoding
    assert_equal 477553583, mobi.header.id
    assert_equal 4, mobi.header.generator_version
    assert_equal 2, mobi.header.first_non_book_index
    assert_equal 352, mobi.header.full_name_offset
    assert_equal 5, mobi.header.full_name_length
    assert_equal 'hello', mobi.header.full_name
    assert_equal 'en-us', mobi.header.language
    assert_equal 4, mobi.header.format_version
    assert_equal 2, mobi.header.image_record_index
    assert_equal 0x50, mobi.header.extended_flags
    assert_equal 0xffffffff, mobi.header.drm_offset
    assert_equal 0, mobi.header.drm_count
    assert_equal 0, mobi.header.drm_size
    assert_equal 0, mobi.header.drm_flags

    assert_equal [
      0x10000,
      0x54,
      0x11000,
      0x0,
      0x4D4F4249, # MOBI
      232,
      Mobi::Header::TYPES.index('BOOK'),
      Mobi::Header::ENCODING.index('ISO-8859-1'),
      477553583,
      4,
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
      2,
      352,
      5,
      Mobi::Header::LANGUAGES['en-us'],
      0, 0,
      4,
      2,
      0, 0, 0, 0,
      0x50,
      0, 0, 0, 0, 0, 0, 0, 0,
      0xffffffff,
      0,
      0,
      0,
      0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
      1163416648, # EXTH
      104,
      5,

      300,
      44,
      16777216, 0, 0, 128, 0, 0, 0, 0, 3203722732,

      204,
      12,
      2,

      205,
      12,
      4,

      206,
      12,
      2,

      207,
      12,
      41
    ], mobi.header.to_a
  end

  def test_open_hello2
    mobi = Mobi.new(fixture(:hello2))

    assert_equal 'hello2', mobi.title
    assert_equal "<html><head><guide></guide></head><body>Hej Verden <mbp:pagebreak/></body></html>\000", mobi.content

    assert_equal 1, mobi.header.compression
    assert_equal false, mobi.header.compressed?
    assert_equal 81, mobi.header.text_length
    assert_equal 1, mobi.header.record_count
    assert_equal 4096, mobi.header.record_size
    assert_equal false, mobi.header.encrypted?

    assert_equal 'MOBI', mobi.header.identifier
    assert_equal 232, mobi.header.size
    assert_equal 'BOOK', mobi.header.type
    assert_equal 'UTF-8', mobi.header.encoding
    assert_equal 2741399991, mobi.header.id
    assert_equal 5, mobi.header.generator_version
    assert_equal 3, mobi.header.first_non_book_index
    assert_equal 352, mobi.header.full_name_offset
    assert_equal 6, mobi.header.full_name_length
    assert_equal 'hello2', mobi.header.full_name
    assert_equal 'da', mobi.header.language
    assert_equal 5, mobi.header.format_version
    assert_equal 3, mobi.header.image_record_index
    assert_equal 0x50, mobi.header.extended_flags
    assert_equal 0xffffffff, mobi.header.drm_offset
    assert_equal 0, mobi.header.drm_count
    assert_equal 0, mobi.header.drm_size
    assert_equal 0, mobi.header.drm_flags
  end

  def test_open_pg148
    mobi = Mobi.new(fixture(:pg148))

    assert_equal 'The Autobiography of Benjamin Franklin', mobi.title
    assert_equal 225749, mobi.content.length

    assert_equal 2, mobi.header.compression
    assert_equal true, mobi.header.compressed?
    assert_equal 397404, mobi.header.text_length
    assert_equal 98, mobi.header.record_count
    assert_equal 4096, mobi.header.record_size
    assert_equal false, mobi.header.encrypted?

    assert_equal 'MOBI', mobi.header.identifier
    assert_equal 232, mobi.header.size
    assert_equal 'BOOK', mobi.header.type
    assert_equal 'ISO-8859-1', mobi.header.encoding
    assert_equal 3294503046, mobi.header.id
    assert_equal 6, mobi.header.generator_version
    assert_equal 100, mobi.header.first_non_book_index
    assert_equal 552, mobi.header.full_name_offset
    assert_equal 38, mobi.header.full_name_length
    assert_equal 'The Autobiography of Benjamin Franklin', mobi.header.full_name
    assert_equal 'en', mobi.header.language
    assert_equal 6, mobi.header.format_version
    assert_equal 105, mobi.header.image_record_index
    assert_equal 0x50, mobi.header.extended_flags
    assert_equal 0xffffffff, mobi.header.drm_offset
    assert_equal 0, mobi.header.drm_count
    assert_equal 0, mobi.header.drm_size
    assert_equal 0, mobi.header.drm_flags
  end

  def test_open_metadata
    mobi = Mobi.new(fixture(:metadata))

    assert_equal 'metadata', mobi.title
    assert_equal '<html><head><guide></guide></head><body>This document has a bunch of metadata. <mbp:pagebreak/></body></html>', mobi.content

    assert_equal 1, mobi.header.compression
    assert_equal false, mobi.header.compressed?
    assert_equal 109, mobi.header.text_length
    assert_equal 1, mobi.header.record_count
    assert_equal 4096, mobi.header.record_size
    assert_equal false, mobi.header.encrypted?

    assert_equal 'MOBI', mobi.header.identifier
    assert_equal 232, mobi.header.size
    assert_equal 'BOOK', mobi.header.type
    assert_equal 'ISO-8859-1', mobi.header.encoding
    assert_equal 65809113, mobi.header.id
    assert_equal 4, mobi.header.generator_version
    assert_equal 3, mobi.header.first_non_book_index
    assert_equal 508, mobi.header.full_name_offset
    assert_equal 8, mobi.header.full_name_length
    assert_equal 'metadata', mobi.header.full_name
    assert_equal 'en-us', mobi.header.language
    assert_equal 4, mobi.header.format_version
    assert_equal 3, mobi.header.image_record_index
    assert_equal 0x50, mobi.header.extended_flags
    assert_equal 0xffffffff, mobi.header.drm_offset
    assert_equal 0, mobi.header.drm_count
    assert_equal 0, mobi.header.drm_size
    assert_equal 0, mobi.header.drm_flags
  end
end
