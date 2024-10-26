#!/bin/sh

file="${1:-.}/allanime.xml"
#header
oldfile="$(cat $file)"
printf '<?xml version="1.0" encoding="UTF-8" ?>\n<rss version="2.0">\n\n<channel>\n<title>Allanime (Sub) - RSS Feed</title>\n<link>https://github.com/coolnsx/anime-rss</link>\n<description>A simple RSS feed for allanime!</description>\n' > $file
query="query(        \$search: SearchInput        \$limit: Int        \$page: Int        \$translationType: VaildTranslationTypeEnumType        \$countryOrigin: VaildCountryOriginEnumType    ) {    shows(        search: \$search        limit: \$limit        page: \$page        translationType: \$translationType        countryOrigin: \$countryOrigin    ) {        edges {            _id name lastEpisodeInfo __typename       }    }}"

currenttime="$(date -Ru)" 

#content
for i in $(curl -e 'https://allanime.to' -s -G "https://api.allanime.day/api" --data-urlencode 'variables={"search":{"sortBy":"Recent","allowAdult":true,"allowUnknown":true},"limit":40,"page":1,"translationType":"sub","countryOrigin":"JP"}' --data-urlencode 'query=query($search: SearchInput $limit: Int $page: Int $translationType: VaildTranslationTypeEnumType $countryOrigin: VaildCountryOriginEnumType) { shows( search: $search limit: $limit page: $page translationType: $translationType countryOrigin: $countryOrigin ) {edges { _id name lastEpisodeInfo __typename thumbnail}}}' -A "Mozilla/5.0" | sed 's|Show|\n|g' | sed -nE 's|.*_id":"([^"]*)","name":"([^"]*)".*sub":\{"episodeString":"([^"]*)".*|\1\t\2\tepisode \3 sub|p' | tr '[:punct:]' ' ' | tr -s ' ' | tr ' \t' '-/');do
	title="$(printf "%s" "$i" | cut -d'/' -f2- | tr '[:punct:]' ' ' )"
	epdate="$(printf '%s' "$oldfile" | grep -A3 "<title>${title}</title>" | grep "<pubDate>" | sed -E 's_<pubDate>([^<>]+)</pubDate>_\1_')"
	printf '\n<item>\n<title>%s</title>\n<link>%s</link>\n<description>A simple RSS feed for allanime!</description>\n<pubDate>%s</pubDate>\n</item>\n' "$title" "https://allmanga.to/bangumi/$(printf "%s" "$i" | cut -d'/' -f1- | sed 's/episode/p/g')" "${epdate:-$currenttime}" >> $file
done

#footer
printf "\n</channel>\n</rss>" >> $file
