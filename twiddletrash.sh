#!/bin/bash

if [ $# -ne 1 ]
then
        echo -e
        echo "Usage:"
        echo -e "\ttwiddlerem.sh /path/to/suidlistfile.txt"
        echo -e
        exit
fi

TWIDDLEPATH=/export/dcm4chee/bin/twiddle.sh
TWUSER=admin
TWPASS=password
TWHOST=127.0.0.1
INPUTFILE=$1

conto=1
tot=`cat $INPUTFILE|wc -l`
conto2=1

while read iuid
do

   echo $conto - $tot - $conto2

   echo ${iuid}

   echo ${TWIDDLEPATH} -s ${TWHOST} -u ${TWUSER} -p ${TWPASS} invoke "dcm4chee.archive:service=ContentEditService" moveStudyToTrash ${iuid}


    ${TWIDDLEPATH} -s ${TWHOST} -u ${TWUSER} -p ${TWPASS} invoke "dcm4chee.archive:service=ContentEditService" moveStudyToTrash ${iuid}

    let conto=$conto+1
    let conto2=$conto2+1

   echo sleep 1
   sleep 1

done < $INPUTFILE
