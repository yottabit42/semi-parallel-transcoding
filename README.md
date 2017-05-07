# Semi-Parallelized Transcoding to h.265/hevc

by Jacob McDonald
*Revision 170505a-yottabit*


## Semi-Parallelized Transcoding to h.265/hevc

The newer h.265/hevc CODEC can save between 50% to 75% of media storage space
for the same visual quality.

Here is a fun script that takes command-line
arguments as directories and parallelizes transcoding of media within those
directories to an h.265/hevc-encoded Matroska (mkv) file with `.x265.` inserted
into the filename, and then if the transcode operation was successful **_will
delete the source file_** (n.b., remove the `&& \ rm "$name"` part of the
script, leaving in place the final `)`, if you do not desire this action).

The script will run one encoding process per directory specified, e.g., if you
specify one directory only one encode process will run at a time; if you specify
five directories, five encoding processes will run simultaneously in parallel.

### File extensions matched for transcoding operation:

* .avi

* .mkv

* .mov

* .mp4

* .mpg

* .ts

If *x265* is present in the filename, the file is skipped.

### Important notes:

* The libx265 encoder process typically uses between 7 and 12 threads in
parallel.

* If specifying multiple directories on the command-line to parallelize the
transcoding, be careful not to overwhelm your system or it could become
unresponsive.

* The encoder process is automatically nice’d to 20 (idle priority; only run
when no other demand is made on the system), so it’s safe to oversubscribe your
CPU threads by some margin.

* As an example, my server uses 16/32 cores/threads Xeon CPU with 64 GB RAM. It
has performed amazingly well with a nice’d load average of 42+ while bulk
transcoding, and was still able to simultaneously live-transcode a Plex stream
to load average of 47 without any noticeable delay or buffering.

* High-quality arguments are passed to the encoder, resulting in file sizes
approximately 33% of original size for a high-quality Blu-Ray 1080p source, and
I can’t visually tell the difference.

* If the encoder fails, the source file will not be removed. This is performed
by the `&&` operator.

* If planning to stream these new files via Plex, or something similar, ensure
the system is fast enough to live-transcode the files back to h.264/avc format
for compatibility with the receiving decoder. (Chromecast requires h.264/avc,
max profile High-L4.1, max bitrate ~12 Mbps, MP4-containerized. Therefore, in
order to successfully live transcode these files to a Chromecast, the server
must be powerful enough to transcode the h.265/hevc source to h.264/avc,
possibly transcode the audio, and containerize to MP4, at at least 30 fps.
(n.b., if you have a slow server, don’t even think about it.)

* **_Worth repeating:_** if the transcode operation is successful **_will delete
the source file_** (n.b., remove the `&& \ rm "$name"` part of the script,
leaving in place the final `)`, if you do not desire this action).

### Requirements:

* ffmpeg

* libx265

* Appropriate decoders for your source media CODEC(s)

* Standard FreeBSD utilities (Bourne sh, find)

* A powerful computer, or patience (or both!)

### Usage:

* `./convert-to-x265.sh ["directory"] [...]`

* Directories with spaces in the name must be quoted or escaped, per usual shell
 usage

* Running with no arguments will exit

* Recommend running in `tmux` to remain running in the background without an
active console session

Test version that echoes filenames to the console instead of performing any
action: `test-convert-to-x265.sh`.

Non-test version: `convert-to-x265.sh`.

### License:

Licensed under **BSD-3-Clause**, the *Modified BSD License*.
