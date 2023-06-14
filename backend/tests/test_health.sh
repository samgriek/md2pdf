#!/bin/bash

curl -o /dev/null -w '%{http_code}\n' https://api-md2pdf.griekinc.com/
