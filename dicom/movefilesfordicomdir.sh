#!/bin/bash

count=0

#find ./conv2 -type d | while read -r file
#do
#
#if [ x"$file" != x"./conv2" ]
#then
#
## echo $file
#
# printf -v j "%04d" $count
#
## echo $j
#
# cp -r $file 4conv/$j
#
# let count=$count+1
#
#fi
#
#done

find ./4conv -type f  | while read -r file
do
echo .
if [ x"$file" != x"./conv2" ]
then

  printf -v j "%04d" $count

  filename=`basename ${file}`
  dirname=`echo $file|sed -e 's/'${filename}'//'`

  mv $file $dirname$j

  let count=$count+1

fi

done
