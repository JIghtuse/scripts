#!/bin/bash
# ugly script for translation words in system buffer

lines=20;
dict="/usr/share/opendict/dictionaries/plain/mueller7.dict.dz/file/mueller7.dict.dz";

string=$(xsel -o)
words=( $string )
len=$(echo "scale=0; $lines / ${#words[@]}" | bc -l)
txt=""

for word in "${words[@]}"; do
	word=`echo $word | sed -e 's/[A-Z]*/\L&/g;s/[,.;:]//g'`;
	if [ -z $word ]; then exit; fi;
	txt="$txt$(zgrep -aA$len '^'$word'$' $dict | sed -e '/^$/d; 1s/^/ &/;/^[^ ]/,$d')"
done
if [ -z $txt ]; then exit; fi;
#zenity --notification --text="$txt"
notify-send "$txt"
