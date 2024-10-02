#!/bin/sh

#header
oldfile="$(cat allanime.xml)"
printf '<?xml version="1.0" encoding="UTF-8" ?>\n<rss version="2.0">\n\n<channel>\n<title>Allanime (Sub) - RSS Feed</title>\n<link>https://github.com/coolnsx/anime-rss</link>\n<description>A simple RSS feed for allanime!</description>\n' > allanime.xml
query="query(        \$search: SearchInput        \$limit: Int        \$page: Int        \$translationType: VaildTranslationTypeEnumType        \$countryOrigin: VaildCountryOriginEnumType    ) {    shows(        search: \$search        limit: \$limit        page: \$page        translationType: \$translationType        countryOrigin: \$countryOrigin    ) {        edges {            _id name lastEpisodeInfo __typename       }    }}"

currenttime="$(date -Ru)" 

#content
for i in $(curl -e 'https://allanime.to' -s -G "https://api.allanime.day/api" -d "variables=%7B%22search%22%3A%7B%22sortBy%22%3A%22Recent%22%2C%22allowAdult%22%3Afalse%2C%22allowUnknown%22%3Afalse%7D%2C%22limit%22%3A40%2C%22page%22%3A1%2C%22translationType%22%3A%22sub%22%2C%22countryOrigin%22%3A%22JP%22%7D" --data-urlencode "query=$query"  -A "Mozilla/5.0" | sed 's|Show|\n|g' | sed -nE 's|.*_id":"([^"]*)","name":"([^"]*)".*sub":\{"episodeString":"([^"]*)".*|\1\t\2\tepisode \3 sub|p' | tr '[:punct:]' ' ' | tr -s ' ' | tr ' \t' '-/');do
	title="$(printf "%s" "$i" | cut -d'/' -f2- | tr '[:punct:]' ' ' )"
	epdate="$(printf '%s' "$oldfile" | grep -A3 "<title>${title}</title>" | grep "<pubDate>" | sed -E 's_<pubDate>([^<>]+)</pubDate>_\1_')"
	printf '\n<item>\n<title>%s</title>\n<link>%s</link>\n<description>A simple RSS feed for allanime!</description>\n<pubDate>%s</pubDate>\n</item>\n' "$title" "https://allanime.site/watch/$(printf "%s" "$i" | cut -d'/' -f1,3)" "${epdate:-$currenttime}" >> allanime.xml
done

#footer
printf "\n</channel>\n</rss>" >> allanime.xml
