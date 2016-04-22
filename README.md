# url-checker

This is a simple bash script which takes as input a file which contains a list of URLs (supporting bash brace expansion) and also an expected HTTP
response code, i.e.

  # Format is Expected HTTP response code component of URL after the DAD
  # e.g. 200 /f?p=123:234:
  404 /{1,2,3,4,5,6}

Then, the script will run a curl command for each URL (after brace expansion has occurred) of the following form:

$ curl -sL -w "%{http_code}" URL -o /dev/null`

This will then output the HTTP response code. If this matches the expected response code from the URLs file, then that is classed as a PASS, if not then it is
consider a FAIL. 

The primary use case for this is to allow a basic level of unit test of a web application.