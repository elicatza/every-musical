#!/usr/bin/env bash

# Have user enter title
# Program will open ibdb, wiki, ovtr, and yt with search queries
# Input fields to fill inn
# Write to json file


set -e

printf "Enter musical title: " && read title
MOZ_ALLOW_DOWNGRADE=1 firefox --new-tab --profile ~/tmp/ffprofile "https://www.youtube.com/results?search_query=${title}+musical+recording"
MOZ_ALLOW_DOWNGRADE=1 firefox --new-tab --profile ~/tmp/ffprofile "https://en.wikipedia.org/w/index.php?search=${title}"
MOZ_ALLOW_DOWNGRADE=1 firefox --new-tab --profile ~/tmp/ffprofile "https://ovrtur.com/search-results?search=${title}"
MOZ_ALLOW_DOWNGRADE=1 firefox --new-tab --profile ~/tmp/ffprofile "https://duckduckgo.com/?q=${title}+site%3Aibdb.com&t=ffsb&ia=web"

printf "Enter opening year: " && read opening
printf "Enter ibdb link: " && read ibdb
printf "Enter ovtr link: " && read ovtr
printf "Enter wiki link: " && read wiki
printf "Enter recording : " && read recording
printf "Enter cover : " && read cover

inner=$(jq -n \
    --argjson favlyric null \
    --argjson favsong null \
    --argjson review null \
    --argjson rating null \
    '$ARGS.named')

outer=$(jq -n \
    --arg title "$title" \
    --argjson opening "$opening" \
    --arg ibdb "$ibdb" \
    --arg ovtr "$ovtr" \
    --arg wiki "$wiki" \
    --arg recording "$recording" \
    --arg cover "$cover" \
    --argjson opinions "$inner" \
    '$ARGS.named')

file=$(jq --argjson outer "$outer" '. += [$outer]' ./ratings.json)
cp -f ratings.json ratings-backup.json
echo -e $file > ratings.json
printf '%s\n' "$(jq . ratings.json)" > ratings.json