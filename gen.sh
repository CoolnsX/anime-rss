#!/bin/sh

rss_file="${1:-.}/allanime.xml"
currenttime="$(date -Ru)"
description="A simple RSS feed using Anilist!"

data=$(printf "$(curl -s "https://graphql.anilist.co" -H "Content-Type: application/json" --data-raw '{"query":"query ($airingAt_greater: Int, $airingAt_lesser: Int) { Page(page: 1, perPage: 50) { airingSchedules(airingAt_greater: $airingAt_greater, airingAt_lesser: $airingAt_lesser, sort: TIME_DESC) { airingAt episode media { countryOfOrigin title { romaji } coverImage { extraLarge } } } } }","variables":{"airingAt_greater":'"$(date -d '24 hour ago' +%s)"',"airingAt_lesser":'"$(date +%s)"'}}' | sed 's/},{/\n/g' | sed -nE 's|.*"airingAt":([^,]*),"episode":([^,]*),"media".*"countryOfOrigin":"JP".*"romaji":"(.*)"\}.*"extraLarge":"(.*)"\}.*|\1\t\4\t\3 Episode \2|p')" | sed 's/\\//g')

#header
printf '<?xml version="1.0" encoding="UTF-8" ?>\n<rss version="2.0" xmlns:media="http://search.yahoo.com/mrss/">\n\n<channel>\n<title>Anilist (Sub) - RSS Feed</title>\n<link>https://github.com/coolnsx/anime-rss</link>\n<description>%s Last Updated at %s</description>\n' "$description" "$currenttime" >"$rss_file"

#content
printf '%s\n' "$data" | tr -s ' ' | tr ' \t' '-~' | while read -r line; do
	title="$(printf "%s" "$line" | cut -d'~' -f3- | tr '[:punct:]' ' ' | tr -s ' ')"
	epdate="$(date -Ru -d"@$(printf '%s' "$line" | cut -d'~' -f1)")"
	thumburl=$(printf "%s" "$line" | cut -d'~' -f2)
	printf '\n<item>\n<title>%s</title>\n<media:thumbnail url="%s" width="90" height="160" />\n<description>%s</description>\n<pubDate>%s</pubDate>\n</item>\n' "$title" "$thumburl" "$description" "${epdate:-$currenttime}" >>"$rss_file"
done

printf "\n</channel>\n</rss>" >>"$rss_file"
