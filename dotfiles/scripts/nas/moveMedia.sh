#!/usr/bin/env bash
#
# Move found media from /mnt/media/ultra mount to /mnt/media/{tv/movies}
# Date: 26.06.24
#
# Debugging
# set -x

read input

fileType=$(echo $input | jq -r .tags[2].filetype)

if [ "$fileType" !=  "file" ]; then
  echo "Event not for file, exiting"
  exit 0
fi

filePath=$(echo $input | jq -r .tags[2].absolute)
targetPath=$(echo "$filePath" | sed 's|/ultra/|/|')

# echo "filePath: $filePath"
# echo "targetPath: $targetPath"

if [[ -z $targetPath && -z $filePath ]]; then
  echo "Missing paths, exiting"
  exit 0
fi

echo "Ensuring path exists - $targetPath"
filePathDir=$(dirname "$targetPath")
# echo "filePathDir: $filePathDir"
mkdir -p "$filePathDir"

echo "Moving file - $filePath"
rsync -avz --remove-source-files "$filePath" "$targetPath"
