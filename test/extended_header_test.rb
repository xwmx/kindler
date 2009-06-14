require 'test_helper'

class ExtendedHeaderTest < Test::Unit::TestCase
  def test_open_hello
    mobi = Mobi.new(fixture(:hello))

    assert_equal 'EXTH', mobi.header.exth_identifier
    assert_equal 104, mobi.header.exth_length
    assert_equal 5, mobi.header.exth_count

    assert_equal 300, mobi.header.extended_headers[0].type
    assert_equal 44, mobi.header.extended_headers[0].length
    assert_equal [0x1000000, 0, 0, 0x80, 0, 0, 0, 0, 0xbef4edec], mobi.header.extended_headers[0].data

    assert_equal 204, mobi.header.extended_headers[1].type
    assert_equal 12, mobi.header.extended_headers[1].length
    assert_equal [2], mobi.header.extended_headers[1].data
    assert_equal [204, 12, 2], mobi.header.extended_headers[1].to_a
    assert_equal "\000\000\000\314\000\000\000\f\000\000\000\002", mobi.header.extended_headers[1].to_s

    assert_equal 205, mobi.header.extended_headers[2].type
    assert_equal 12, mobi.header.extended_headers[2].length
    assert_equal [4], mobi.header.extended_headers[2].data
    assert_equal [205, 12, 4], mobi.header.extended_headers[2].to_a
    assert_equal "\000\000\000\315\000\000\000\f\000\000\000\004", mobi.header.extended_headers[2].to_s

    assert_equal 206, mobi.header.extended_headers[3].type
    assert_equal 12, mobi.header.extended_headers[3].length
    assert_equal [2], mobi.header.extended_headers[3].data
    assert_equal [206, 12, 2], mobi.header.extended_headers[3].to_a
    assert_equal "\000\000\000\316\000\000\000\f\000\000\000\002", mobi.header.extended_headers[3].to_s

    assert_equal 207, mobi.header.extended_headers[4].type
    assert_equal 12, mobi.header.extended_headers[4].length
    assert_equal [41], mobi.header.extended_headers[4].data
    assert_equal [207, 12, 41], mobi.header.extended_headers[4].to_a
    assert_equal "\000\000\000\317\000\000\000\f\000\000\000)", mobi.header.extended_headers[4].to_s
  end

  def test_open_hello2
    mobi = Mobi.new(fixture(:hello2))

    assert_equal 'EXTH', mobi.header.exth_identifier
    assert_equal 104, mobi.header.exth_length
    assert_equal 5, mobi.header.exth_count

    assert_equal 300, mobi.header.extended_headers[0].type
    assert_equal 44, mobi.header.extended_headers[0].length
    assert_equal [0x1000000, 0, 0, 0x80, 0, 0, 0, 0, 0xedecbef4], mobi.header.extended_headers[0].data

    assert_equal 204, mobi.header.extended_headers[1].type
    assert_equal 12, mobi.header.extended_headers[1].length
    assert_equal [2], mobi.header.extended_headers[1].data

    assert_equal 205, mobi.header.extended_headers[2].type
    assert_equal 12, mobi.header.extended_headers[2].length
    assert_equal [4], mobi.header.extended_headers[2].data

    assert_equal 206, mobi.header.extended_headers[3].type
    assert_equal 12, mobi.header.extended_headers[3].length
    assert_equal [2], mobi.header.extended_headers[3].data

    assert_equal 207, mobi.header.extended_headers[4].type
    assert_equal 12, mobi.header.extended_headers[4].length
    assert_equal [41], mobi.header.extended_headers[4].data
  end

  def test_open_pg148
    mobi = Mobi.new(fixture(:pg148))

    assert_equal 'EXTH', mobi.header.exth_identifier
    assert_equal 304, mobi.header.exth_length
    assert_equal 13, mobi.header.exth_count

    assert_equal 'publishingdate', mobi.header.extended_headers[0].type
    assert_equal 18, mobi.header.extended_headers[0].length
    assert_equal '1994-07-01', mobi.header.extended_headers[0].data
    assert_equal [106, 18, 825833780, 758134573], mobi.header.extended_headers[0].to_a
    assert_equal "\000\000\000j\000\000\000\0221994-07-", mobi.header.extended_headers[0].to_s

    assert_equal 'author', mobi.header.extended_headers[1].type
    assert_equal 25, mobi.header.extended_headers[1].length
    assert_equal 'Benjamin Franklin', mobi.header.extended_headers[1].data

    assert_equal 'publisher', mobi.header.extended_headers[2].type
    assert_equal 25, mobi.header.extended_headers[2].length
    assert_equal 'Project Gutenberg', mobi.header.extended_headers[2].data

    assert_equal 'subject', mobi.header.extended_headers[3].type
    assert_equal 37, mobi.header.extended_headers[3].length
    assert_equal 'Franklin, Benjamin, 1706-1790', mobi.header.extended_headers[3].data

    assert_equal 'subject', mobi.header.extended_headers[4].type
    assert_equal 47, mobi.header.extended_headers[4].length
    assert_equal 'Statesmen -- United States -- Biography', mobi.header.extended_headers[4].data

    assert_equal 'rights', mobi.header.extended_headers[5].type
    assert_equal 21, mobi.header.extended_headers[5].length
    assert_equal 'Public domain', mobi.header.extended_headers[5].data

    assert_equal 'source', mobi.header.extended_headers[6].type
    assert_equal 15, mobi.header.extended_headers[6].length
    assert_equal '148.txt', mobi.header.extended_headers[6].data

    assert_equal 'startreading', mobi.header.extended_headers[7].type
    assert_equal 12, mobi.header.extended_headers[7].length
    assert_equal "\000\000\000`", mobi.header.extended_headers[7].data

    assert_equal 300, mobi.header.extended_headers[8].type
    assert_equal 44, mobi.header.extended_headers[8].length
    assert_equal [0x1000000, 0, 0, 0x80, 0, 0, 0, 0, 0xf4edecbe], mobi.header.extended_headers[8].data

    assert_equal 204, mobi.header.extended_headers[9].type
    assert_equal 12, mobi.header.extended_headers[9].length
    assert_equal [1], mobi.header.extended_headers[9].data

    assert_equal 205, mobi.header.extended_headers[10].type
    assert_equal 12, mobi.header.extended_headers[10].length
    assert_equal [6], mobi.header.extended_headers[10].data

    assert_equal 206, mobi.header.extended_headers[11].type
    assert_equal 12, mobi.header.extended_headers[11].length
    assert_equal [2], mobi.header.extended_headers[11].data

    assert_equal 207, mobi.header.extended_headers[12].type
    assert_equal 12, mobi.header.extended_headers[12].length
    assert_equal [41], mobi.header.extended_headers[12].data
  end

  def test_open_metadata
    mobi = Mobi.new(fixture(:metadata))

    assert_equal 'EXTH', mobi.header.exth_identifier
    assert_equal 260, mobi.header.exth_length
    assert_equal 15, mobi.header.exth_count

    assert_equal 'publishingdate', mobi.header.extended_headers[0].type
    assert_equal 18, mobi.header.extended_headers[0].length
    assert_equal '06/13/2009', mobi.header.extended_headers[0].data

    assert_equal 'isbn', mobi.header.extended_headers[1].type
    assert_equal 12, mobi.header.extended_headers[1].length
    assert_equal 'ISBN', mobi.header.extended_headers[1].data

    assert_equal 'author', mobi.header.extended_headers[2].type
    assert_equal 14, mobi.header.extended_headers[2].length
    assert_equal 'Author', mobi.header.extended_headers[2].data

    assert_equal 'publisher', mobi.header.extended_headers[3].type
    assert_equal 17, mobi.header.extended_headers[3].length
    assert_equal 'Publisher', mobi.header.extended_headers[3].data

    assert_equal 'subjectcode', mobi.header.extended_headers[4].type
    assert_equal 17, mobi.header.extended_headers[4].length
    assert_equal 'NON000000', mobi.header.extended_headers[4].data

    assert_equal 'subject', mobi.header.extended_headers[5].type
    assert_equal 17, mobi.header.extended_headers[5].length
    assert_equal 'Undefined', mobi.header.extended_headers[5].data

    assert_equal 'description', mobi.header.extended_headers[6].type
    assert_equal 19, mobi.header.extended_headers[6].length
    assert_equal 'Description', mobi.header.extended_headers[6].data

    assert_equal 'review', mobi.header.extended_headers[7].type
    assert_equal 14, mobi.header.extended_headers[7].length
    assert_equal 'Review', mobi.header.extended_headers[7].data

    assert_equal 'price', mobi.header.extended_headers[8].type
    assert_equal 15, mobi.header.extended_headers[8].length
    assert_equal '1000000', mobi.header.extended_headers[8].data

    assert_equal 'currency', mobi.header.extended_headers[9].type
    assert_equal 11, mobi.header.extended_headers[9].length
    assert_equal 'USD', mobi.header.extended_headers[9].data

    assert_equal 300, mobi.header.extended_headers[10].type
    assert_equal 44, mobi.header.extended_headers[10].length
    assert_equal [0x1000000, 0, 0, 0x80, 0, 0, 0, 0, 0xedecbef4], mobi.header.extended_headers[10].data

    assert_equal 204, mobi.header.extended_headers[11].type
    assert_equal 12, mobi.header.extended_headers[11].length
    assert_equal [2], mobi.header.extended_headers[11].data

    assert_equal 205, mobi.header.extended_headers[12].type
    assert_equal 12, mobi.header.extended_headers[12].length
    assert_equal [4], mobi.header.extended_headers[12].data

    assert_equal 206, mobi.header.extended_headers[13].type
    assert_equal 12, mobi.header.extended_headers[13].length
    assert_equal [2], mobi.header.extended_headers[13].data

    assert_equal 207, mobi.header.extended_headers[14].type
    assert_equal 12, mobi.header.extended_headers[14].length
    assert_equal [41], mobi.header.extended_headers[14].data
  end
end
