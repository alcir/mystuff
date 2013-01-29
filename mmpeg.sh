#!/bin/bash

# Audio related
AUD_CODEC=mp3
AUD_BITRATE=64k
AUD_BITRATE=128k

# Video related
VID_CODEC="mpeg4 -vtag XVID"
VID_KEYFRAME_FREQ=30   # As per vimeo's recommendation.
VID_BITRATE=900k       # Video bitrate, higher values give better quality
                       # but larger file size
VID_BITRATE=2000k       # Video bitrate, higher values give better quality
VID_INPUT_INTERLACED=1 # 1, if your input video is interlaced. 0, if not.
                       # Most camcorders have interlaced video. So if you
                       # are not sure, leave this on.
VID_169_TO_43=1        # Set to 1 if you want to convert 16:9 to 4:3
VID_LETTERBOX_COLOR="000000" # Color of bars at the top and bottom
                             # When a widescreen input is converted
                             # 000000 = black ffffff=white

 

# Misc
SYS_NUM_THREADS=auto      # Number of processing threads.
FFMPEG=/usr/bin/ffmpeg

###############################################################################
### DON'T EDIT ANYTHING BEYOND THIS POINT #####################################
###############################################################################

DEINTERLACE=
[ $VID_INPUT_INTERLACED == 1 ] && DEINTERLACE="-filter:v yadif"

SIZECHANGE=
[ $VID_169_TO_43 == 1 ] && \
  SIZECHANGE="-s 640x360 -aspect 4:3"

[ $# -eq 0 ] &&
   echo "Need the dv file to convert (Syntax: $0 <input.dv>)" && exit 1

INPUT=$1

OUTPUT=${1/.dv/.avi}
OUTPUT=${OUTPUT////_}

echo "Converting $INPUT => $OUTPUT"

$FFMPEG -threads $SYS_NUM_THREADS   \
       -f dv                        \
       -i $INPUT                    \
       -vcodec $VID_CODEC           \
       -g $VID_KEYFRAME_FREQ        \
       $DEINTERLACE                 \
       -b:v $VID_BITRATE            \
       $SIZECHANGE                  \
       -acodec $AUD_CODEC           \
       -ab $AUD_BITRATE             \
       -qmin 5                      \
       -v info                      \
       /media/003-9VT166/converted/$OUTPUT
