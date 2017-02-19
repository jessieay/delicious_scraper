# Delicious scraper

## What is this?

Delicious.com, (or http://del.icio.us/ depending on the day...) has gone through
manys ups and downs over the past few years. There is an export functionality
but it wasn't exporting everything correctly. I wrote this little ruby script to
scrape links and put them into a format compatible with what https://pinboard.in
expects for import.

## Instructions for use

This script expects two arguments: your Delicious username and the number of
pages of bookmarks you have on Delicious. NOTE: This scraper does not access
private bookmarks (alas, Delicious API token generation seems to be totally
broken).

Dependencies:

* Ruby
* [Nokogiri](https://github.com/sparklemotion/nokogiri)

Example: (for my account, http://del.icio.us/jessieayoung)

```
$ git clone git@github.com:jessieay/delicious_scraper.git
$ cd delicous_scraper
$ ruby tasty_scraper.rb jessieayoung 85
```

This will output a file called `delicious_export.html`, which you can import
directly to Pinboard.

If you are having issues importing your bookmarks to Pinboard, this may mean
that you have a bookmark with "unescaped markup" (eg: `<a>` tag) somewhere in
your export.

Opening one extremely large export file can be difficult for a laptop. So, I
also wrote a paginated scraper that will export your bookmarks in chunks of 15
pages (150 bookmarks per file). Example:

```
$ cd delicous_scraper
$ ruby tasty_paginated_scraper.rb jessieayoung 85
```

Since I have 85 pages of bookmarks, this outputs 6 files with the following
naming convention:

```
delicious_export_1.html
delicious_export_2.html
...
```

These files can also be imported to pinboard but are mostly useful for debugging
issues with bookmarks that contain troublesome markup. Look for HTML tags in
your bookmark titles and links.
