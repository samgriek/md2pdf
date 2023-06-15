#!/bin/bash

curl -o /dev/null -w 'status code = %{http_code}\n' https://api-md2pdf.griekinc.com/
