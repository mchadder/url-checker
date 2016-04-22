# url-checker

This is a simple bash script which takes as input a file which contains a list of URLs (supporting bash brace expansion) and also an expected HTTP
response code, i.e.

 # Format is Expected HTTP response code component of URL after the DAD
 # e.g. 200 http://server:port/uri
 # bash brace expansion is supported as the example below shows.
 404 http://localhost:8000/{1,2,3,4,5,6}

Comments are allowed by using the normal convention of prepending the line with a #.

Then, the script will run a curl command for each URL (after brace expansion has occurred) of the following form:

$ curl -sL -w "%{http_code}" URL -o /dev/null`

This will then output the HTTP response code. If this matches the expected response code from the URLs file, then that is classed as a PASS, if not then it is
consider a FAIL, the following is example output using the example urls.txt file.

 $ ./url-checker.sh urls.txt N Y
 FAIL! RECEIVED 000 BUT EXPECTED 404        : http://localhost:8000/1
 FAIL! RECEIVED 000 BUT EXPECTED 404        : http://localhost:8000/2
 FAIL! RECEIVED 000 BUT EXPECTED 404        : http://localhost:8000/3
 FAIL! RECEIVED 000 BUT EXPECTED 404        : http://localhost:8000/4
 FAIL! RECEIVED 000 BUT EXPECTED 404        : http://localhost:8000/5
 FAIL! RECEIVED 000 BUT EXPECTED 404        : http://localhost:8000/6

The primary use case for this is to allow a basic level of unit test of a web application.