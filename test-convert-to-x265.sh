#!/bin/sh
#
# Tests semi-parallel transcoding loops by echoing filenames that would be
# processed. See convert-to-x265.sh for the script that actually performs the
# transcoding.
#
# Also available in a convenient Google Doc:
# https://docs.google.com/document/d/1LSr3J6hdnCDQHfiH45K3HMvEqzbug7GeUeDa_6b_Hhc
#
# Jacob McDonald
# Revision 170504a-yottabit

IFS="$(printf '\n\t')"

while [ $# -gt 0 ]
do

for name in `find "./$1" \
\( \
-name "*.avi" \
-or -name "*.mkv" \
-or -name "*.mov" \
-or -name "*.mp4" \
-or -name "*.mpg" \
-or -name "*.ts" \
\) \
-and -not -iname "*x265*" \
-type f -print`

do
( echo "$name" && echo "success" )
done &

# next dir loop
shift
done
