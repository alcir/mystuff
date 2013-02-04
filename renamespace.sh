#!/bin/bash

find . -type f | while read -r FILE
do

  echo $FILE |grep " " >/dev/null
  EL=$?

  echo $EL  $FILE
  
  if [ $EL -eq 0 ]
  then   
    mv -v "$FILE" `echo $FILE | tr ' ' '_' `
  fi

done
