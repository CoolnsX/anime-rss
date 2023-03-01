#!/bin/sh

#header
printf '<?xml version="1.0" encoding="UTF-8" ?>\n<rss version="2.0">\n\n<channel>\n<title>Allanime (Sub) - RSS Feed</title>\n<link>https://github.com/coolnsx/anime-rss</link>\n<description>A simple RSS feed for allanime!</description>\n' > allanime.xml

curl -s -X OPTIONS "https://api.allanime.to/allanimeapi?variables=%7B%22search%22%3A%7B%22sortBy%22%3A%22Recent%22%2C%22allowAdult%22%3Afalse%2C%22allowUnknown%22%3Afalse%7D%2C%22limit%22%3A40%2C%22page%22%3A1%2C%22translationType%22%3A%22sub%22%2C%22countryOrigin%22%3A%22JP%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%22c4305f3918591071dfecd081da12243725364f6b7dd92072df09d915e390b1b7%22%7D%7D -A "Mozilla/5.0"

#content
for i in $(curl -s "https://api.allanime.to/allanimeapi?variables=%7B%22search%22%3A%7B%22sortBy%22%3A%22Recent%22%2C%22allowAdult%22%3Afalse%2C%22allowUnknown%22%3Afalse%7D%2C%22limit%22%3A40%2C%22page%22%3A1%2C%22translationType%22%3A%22sub%22%2C%22countryOrigin%22%3A%22JP%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%22c4305f3918591071dfecd081da12243725364f6b7dd92072df09d915e390b1b7%22%7D%7D" -A Mozilla/5.0 | sed 's|Show|\n|g' | sed -nE 's|.*_id":"([^"]*)","name":"([^"]*)".*sub":\{"episodeString":"([^"]*)".*|\1\t\2\tepisode \3 sub|p' | tr '[:punct:]' ' ' | tr -s ' ' | tr ' \t' '-/');do
        printf '\n<item>\n<title>%s</title>\n<link>%s</link>\n<description>A simple RSS feed for allanime!</description>\n</item>\n' "$(printf "%s" "$i" | cut -d'/' -f2- | tr '[:punct:]' ' ' )" "https://allanime.site/watch/$(printf "%s" "$i" | cut -d'/' -f1,3)" >> allanime.xml
done

#footer
printf "\n</channel>\n</rss>" >> allanime.xml
