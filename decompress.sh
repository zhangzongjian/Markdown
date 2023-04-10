#!/bin/bash

file_name=$(basename $0)
zipFileName=""

function doExtrJarArchive() {
  doExtrZipArchive $1 $2
}

function doExtrWarArchive() {
    doExtrZipArchive $1 $2
}

function doExtrZipArchive() {
  local archiveFile=$1
  local extractDir=$2
  unzip -o $archiveFile -d $extractDir > /dev/null
}

function doExtrTargzArchive() {
  local archiveFile=$1
  local extractDir=$2
  tar -xzvf $archiveFile -C $extractDir > /dev/null
}

function getExtName() {
  local fileName=$1
  if [[ "$archiveFile" == *.zip ]]; then
    echo "zip"
  elif [[ "$archiveFile" == *.tar.gz ]]; then
    echo "tar.gz"
  elif   [[ "$archiveFile" == *.jar ]]; then
    echo "jar"
  elif [[ "$archiveFile" == *.war ]]; then
    echo "war"
  else
    echo 1
  fi
}

function doExtractArchive() {
  local flag="0"
  local archiveFile=$1
  echo $1
  local extName=$(getExtName $archiveFile)
  if test ${extName} = "1"; then
    echo "Arguments is not zip or tar.gz, file name is $archiveFile"
    exit 1
  fi

  if test $archiveFile == $zipFileName; then
    flag="1"
  fi

  local archiveZipName=$(basename $archiveFile)
  local archiveFileName=$(basename $archiveFile | sed "s/\.${extName}//g")
  if test $flag == "0"; then
    archiveFileName=${archiveFileName}_1
  fi
  local archiveDirName=$(dirname $archiveFile)
  [ -d $archiveDirName/$archiveZipName ] && echo "file already decompress." && return
  mkdir -p $archiveDirName/$archiveFileName
  if [[ "$archiveFile" == *.zip ]]; then
    doExtrZipArchive $archiveFile $archiveDirName/$archiveFileName
  elif [[ "$archiveFile" == *.tar.gz ]]; then
    doExtrTargzArchive $archiveFile $archiveDirName/$archiveFileName
  elif [[ "$archiveFile" == *.jar ]]; then
    doExtrJarArchive $archiveFile $archiveDirName/$archiveFileName
  elif [[ "$archiveFile" == *.war ]]; then
    doExtrWarArchive $archiveFile $archiveDirName/$archiveFileName
  else
    echo "Arguments is not zip or tar.gz or jar or war, file name is $archiveFile"
    return
  fi

  if test $flag == "0"; then
    rm $archiveDirName/$archiveZipName
    mv $archiveDirName/$archiveFileName $archiveDirName/$archiveZipName
  else
    archiveZipName=$archiveFileName
  fi

  for file in $(find $archiveDirName/$archiveZipName -name '*.zip' -o -name '*.tar.gz' -o -name '*.jar' -o -name '*.war'); do
    if [ -f $file ]; then
      doExtractArchive "$file"
    fi
  done
}

function main() {
  zipFileName=$1
  echo "decompress file begin."
  doExtractArchive $1
  echo "decompress file finished."
}

main $@
