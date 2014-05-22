#!/bin/bash

#medcon -contrast -c dicom -f ~/mount/iso/nome\ paziente\ 18-06-1926/1999-12-27ll.acr

#find ./conv | while read -r file
#do
#    # replace " - " or space or dash with underscores
#    # remove exclamation points and commas
#    newfile=$(echo "$file" | sed 's/\ /_/g;')
#    mv "$file" "$newfile"
#done

#sleep 3

find ./conv -type d | while read -r file
do

 cd $file

 pwd

 a=`pwd`

 if [ x"$a" != x"/home/alessio/tmp/conv" ]
 then

  find . -type f | while read acrfile
  do

   medcon -contrast -c dicom -o $acrfile.dcm -f $acrfile

  done

 fi

 cd ~/tmp

done
