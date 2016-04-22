#!/bin/bash
# Syntax: ./url-checker.sh <filename> <show_passes>[Y|N] <show_fails>[Y|N]
if [ -f "$1" -a "$2" != "" -a "$3" != "" ]
then
  URL_ROOT="http://localhost:8000"

  while read p; do
    if [[ ${p:0:1} != "#" ]]
    then
      HTTP_CODE=`echo $p | cut -f 1 -d " "`
      URL=`echo $p | cut -f 2 -d " "`

      FULL_URL=$URL_ROOT$URL

      # Have to use the dread eval() here since brace expansion occurs before 
      # parameter expansion. Be careful that the URL list in the file 
      # does not contain any arbitrary UNIX commands. Ideally, should validate that the output
      # is a valid URL before running it through eval().
      for OUTPUT_URL in $(eval echo $FULL_URL);
      do 
        CURL=`curl -sL -w "%{http_code}" $OUTPUT_URL -o /dev/null`

        if [ $CURL != $HTTP_CODE ]
        then
          if [ "$3" != "N" ]
          then 
            echo "FAIL! RECEIVED $CURL BUT EXPECTED $HTTP_CODE        : $OUTPUT_URL"
          fi
        else
          if [ "$2" != "N" ] 
          then
            echo "PASS: RECEIVED $CURL AS EXPECTED             : $OUTPUT_URL"
          fi
        fi
      done
    fi
  done < "$1"
else
  echo "Syntax: url-checker.sh <file_of_url_components> <show_passes [Y|N]> <show_fails [Y|N]>"
fi
