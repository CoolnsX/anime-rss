#!/bin/sh

printf '<?xml version="1.0" encoding="UTF-8" ?>\n<rss version="2.0">\n\n<channel>\n<title>Allanime (Sub) - RSS Feed</title>\n<link>https://github.com/coolnsx/anime-rss</link>\n<description>A simple RSS feed for allanime!</description>\n' > allanime.xml
for i in $(curl -s "https://allanime.site/allanimeapi?variables=%7B%22search%22%3A%7B%22sortBy%22%3A%22Recent%22%2C%22allowAdult%22%3Afalse%2C%22allowUnknown%22%3Afalse%7D%2C%22limit%22%3A26%2C%22page%22%3A1%2C%22translationType%22%3A%22sub%22%2C%22countryOrigin%22%3A%22JP%22%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%229c7a8bc1e095a34f2972699e8105f7aaf9082c6e1ccd56eab99c2f1a971152c6%22%7D%7D" -A "uwu" | sed 's/Show/\n/g' | sed -nE 's|.*id":"([^"]*)","name":"([^"]*)".*sub":([^,]*).*|\1\t\2\tepisode \3 sub|p' | tr -d '[:punct:]' | tr ' \t' '-/');do 
	printf '\n<item>\n<title>%s</title>\n<link>%s</link>\n</item>\n<description>A simple RSS feed for allanime!</description>\n' "$(printf "%s" "$i" | cut -d'/' -f2- | tr '[:punct:]' ' ' )" "https://allanime.site/watch/$i" >> allanime.xml
done
printf "\n</channel>\n</rss>" >> allanime.xml
