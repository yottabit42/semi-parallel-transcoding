#!/bin/sh
#
# This script takes one or more files or directories as command-line arguments
# and sequentially iterates through all files within each argument (assuming
# the argument is a directory). Each argument is parallelized. Example:
#   ./convert_to_x265.sh dir1
# would sequentially transcode all files in dir1
#   ./convert_to_x265.sh dir1 dir2 dir3
# would parallel transcode one file at a time from each of the three
# directories in parallel, so there would be three encodes running in parallel
# at any one time (and decreasing over time if some directories finish before
# others).
#
# The output file will have .x265. inserted into the filename. Any files match-
# ing *x265* will be excluded from the transcoding process. This allows running
# the script many times for a given directory, even on a schedule through cron,
# and always convert only files that have not already been converted.
#
# If the transcode operation is  successful, THE SOURCE FILE WILL BE DELETED
# (n.b., remove the && \ rm "$name" part of the script, leaving in place the
# final ')', if you do not desire this action).
#
# For more detail and information, see:
# https://docs.google.com/document/d/1LSr3J6hdnCDQHfiH45K3HMvEqzbug7GeUeDa_6b_Hhc
#
# Jacob McDonald
# Revision 170505a-yottabit
#
# Licensed under BSD-3-Clause, the Modified BSD License

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
( time ffmpeg -loglevel info -y -threads 0 -i "$name" \
-vcodec libx265 -strict 2 -threads 0 -preset medium -crf 18 -x265-params level=4.1 \
-acodec copy \
"$name.x265.mkv" && \
rm "$name" )
done &

# next dir loop
shift
done
