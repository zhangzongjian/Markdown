#!/bin/bash

zipFileName=""
support_ext=".zip|.tar.gz|.jar|.war"
support_ext=${support_ext//\./\\.}

function extract() {
  local archiveFile=$1
  local extractDir=$2
  if [[ "$archiveFile" == *.zip ]] || [[ "$archiveFile" == *.jar ]] || [[ "$archiveFile" == *.war ]]; then
    unzip -o "$archiveFile" -d "$extractDir" > /dev/null
  elif [[ "$archiveFile" == *.tar.gz ]]; then
    tar -xzvf "$archiveFile" -C "$extractDir" > /dev/null
  fi
}

function doExtractArchive() {
  echo "$1"
  local archiveFile="$1"
  local archiveZipName=$(basename "$archiveFile")
  local archiveFileName=$(basename "$archiveFile" | perl -pe "s#${support_ext}\$##g")
  [ "$archiveFile" != "$zipFileName" ] && archiveFileName="${archiveFileName}_1"
  local archiveDirName=$(dirname "$archiveFile")
  mkdir -p "$archiveDirName/$archiveFileName"
  extract "$archiveFile" "$archiveDirName/$archiveFileName"

  if test "$archiveFile" != "$zipFileName"; then
    rm "$archiveDirName/$archiveZipName"
    mv "$archiveDirName/$archiveFileName" "$archiveDirName/$archiveZipName"
  else
    archiveZipName=$archiveFileName
  fi

  for file in $(find "$archiveDirName/$archiveZipName" -type f | grep -E "(${support_ext})\$"); do
    doExtractArchive "$file"
  done
}

function main() {
  zipFileName="$1"
  echo "decompress file begin."
  doExtractArchive "$1"
  echo "decompress file finished."
}

main "$@"
