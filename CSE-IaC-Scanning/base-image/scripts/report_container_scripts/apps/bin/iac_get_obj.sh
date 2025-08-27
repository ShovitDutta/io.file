#!/usr/bin/env sh

   p1=${1:-NONE}
   p2=${2:-NONE}
   p3=${3:-NONE}
   p4=${4:-NONE}
   p5=${5:-NONE}

   if [[ "${p1}" != "NONE" ]]  &&  [[ "${p2}" != "NONE" ]] && [[ "${p3}" != "NONE" ]] && [[ "${p4}" != "NONE" ]] || [[ "${p5}" != "NONE" ]] ; then
       :
   else
       echo "INFO: Total number of parameters  $# less than 4. Minimum Required is 4 "
       echo "INFO: USAGE $0 DATE STORAGE_FOLDER TYPE TARGET_DIRECTORY (4) Required."
       exit 100
   fi

   echo "INFO: process"
