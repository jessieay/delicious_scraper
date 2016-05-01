require 'nokogiri'
require 'open-uri'
require 'pry'

number_of_pages = ARGV[0].to_i

page_data = []

(1..number_of_pages).to_a.each do |number|
  url = "http://del.icio.us/jessieayoung?&page=#{number}"
  doc = Nokogiri::HTML(open(url))
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

File.open("delicious_export.html", "w") do |f|
  f.write(page_data.join("\n"))
end

