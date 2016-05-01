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

Example: (for my account, http://del.icio.us/jessieayoung)

```
$ git clone git@github.com:jessieay/delicious_scraper.git
$ cd delicous_scraper
$ ruby tasty_scraper.rb jessieayoung 85
```

This will output a file called `delicious_export.html`, which you can import
directly to Pinboard.
