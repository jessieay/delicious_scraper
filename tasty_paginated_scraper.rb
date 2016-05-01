require 'nokogiri'
require 'open-uri'
require 'pry'

username = ARGV[0]
number_of_pages = ARGV[1].to_i
ranges = (1..number_of_pages).to_a.each_slice(15).to_a
iteration = 1

ranges.each do |range|
  page_data = []

  range.each do |page|
    delicious_url = "http://del.icio.us/#{username}?&page=#{page}"
    doc = Nokogiri::HTML(open(delicious_url))

    date_selector = '.articleThumbBlockOuter'

    dates = doc.search(date_selector).map do |date|
      date.attr("date")
    end

    url_selector = '.articleInfoPan'

    links = doc.search(url_selector).map do |url|
      url.search('a')[0]['href']
    end

    tags_selector = '.tagName'

    tags = doc.search(tags_selector).map do |tag_list|
      all_tags = tag_list.search('a').map do |tag|
        tag.text
      end

      all_tags.join(",")
    end

    title_selector = '.articleTitlePan'

    titles = doc.search(title_selector).map do |title|
      title.search('h3').text
    end

    description_selector = '.thumbTBriefTxt'

    descriptions = doc.search(description_selector).map do |description|
      if description.search('p')[1]
        description.search('p')[1].text
      else
        nil
      end
    end

    grouped_attributes = links.zip(dates, tags, titles, descriptions)

    formatted_attributes = grouped_attributes.map do |attrs|
      "<DT><A HREF='#{attrs[0]}' ADD_DATE='#{attrs[1]}'"\
        " PRIVATE='0' TAGS='#{attrs[2]}'>"\
        "#{attrs[3]}</A><DD>#{attrs[4]}"
    end

    page_data << formatted_attributes
  end

  top_text = "<!DOCTYPE NETSCAPE-Bookmark-file-1>"\
    "<META HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=UTF-8'>"\
    "<TITLE>Bookmarks</TITLE>"\
    "<H1>Bookmarks</H1>"\
    "<DL><p>"

  bottom_text = "</DL><p>"

  File.open("delicious_export_#{iteration}.html", "w") do |f|
    f.write(top_text + page_data.join("\n") + bottom_text)
  end

  iteration += 1
end
