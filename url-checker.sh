#!/bin/bash
# Syntax: ./url-checker.sh <filename> <show_passes>[Y|N] <show_fails>[Y|N]

# Check to see if $1 is a file AND $2 is specified AND $3 is specified. If not, then fail.
if [ -f "$1" -a "$2" != "" -a "$3" != "" ]
then
  # Check to see if curl is installed. Do this using the built-in hash command.
  if hash curl 2>/dev/null; then
    while read p; do
      # Ignore # comment lines. Note, the # has to be the first character.
      if [[ ${p:0:1} != "#" ]]
      then
        # The format of the file is: 404 URL, so use cut to split on space
        # the first field will be the error code and the second will be the 
        # URL pattern.
        HTTP_CODE=`echo $p | cut -f 1 -d " "`
        URL=`echo $p | cut -f 2 -d " "`

        # Have to use the dread eval() here since brace expansion occurs before 
        # parameter expansion. Be careful that the URL list in the file 
        # does not contain any arbitrary UNIX commands. Ideally, should validate that the output
        # is a valid URL before running it through eval().
        for OUTPUT_URL in $(eval echo "$URL");
        do 
          # Generate the curl command to output the HTTP response code
          CURL=`curl -sL -w "%{http_code}" $OUTPUT_URL -o /dev/null`

          if [ $CURL != $HTTP_CODE ]
          then
            # Check to see if the third parameter (show fails) defines that we should
            # display the output or not.
            if [ "$3" != "N" ]
            then 
              echo "FAIL! RECEIVED $CURL BUT EXPECTED $HTTP_CODE        : $OUTPUT_URL"
            fi
          else
            # Check to see if the second parameter (show passes) defines that we should
            # display the output or not.
            if [ "$2" != "N" ] 
            then
              echo "PASS: RECEIVED $CURL AS EXPECTED             : $OUTPUT_URL"
            fi
          fi
        done
      fi
    done < "$1"
  else
    # Output a message because the dependencies are not present.
    echo "Cannot run. This script requires the curl command to execute."    

    # Exit with failure
    exit 1
  fi
else
  # Command line syntax incorrect, display the standard syntax information.
  echo "Syntax: ./url-checker.sh <file_of_url_components> <show_passes [Y|N]> <show_fails [Y|N]>"
  echo "e.g. ./url-checker.sh urls.txt N Y"

  # Exit with failure
  exit 1
fi

# Exit successfully
exit 0
