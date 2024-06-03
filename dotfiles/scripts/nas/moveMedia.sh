#!/usr/bin/env bash
#
# Move found media from /mnt/media/ultra mount to /mnt/media/{tv/movies}
# Date: 26.06.24

if [ ! -z "$(/usr/bin/ls -A /mnt/media/ultra/movies/)" ]; then
  echo "Moving Movie files.."
  rsync -avz --remove-source-files /mnt/media/ultra/movies/* /mnt/media/movies/
fi

if [ ! -z "$(/usr/bin/ls -A /mnt/media/ultra/tv/)" ]; then
  echo "Moving TV files.."
  rsync -avz --remove-source-files /mnt/media/ultra/tv/* /mnt/media/tv/
fi

echo "Complete
