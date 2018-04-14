#!/bin/sh

/usr/local/bin/lighthouse \
	--chrome-flags='--headless --disable-gpu --no-sandbox' \
	--output json \
	--output html \
	--output-path="/var/app/reports/${REPORT_NAME}" \
	${CHECK_URL}


