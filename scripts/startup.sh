#!/bin/sh

if [ "${CHECK_URL}" = "" ]; then
	echo "no CHECK_URL"
	exit 1
fi

# 
if [ "${REPORT_NAME}" = "" ]; then
	REPORT_NAME=`date "+%Y%m%d%H%M"`
fi

# lighthouse確認
/usr/local/bin/lighthouse \
	--chrome-flags='--headless --disable-gpu --no-sandbox' \
	--output json \
	--output html \
	--output-path="/app/reports/${REPORT_NAME}" \
	${CHECK_URL}

# slack送信
if [ "${SLACK_CHANNEL}" != "" ]  && [ "${SLACK_URL}" != "" ]; then
	/app/scripts/slack.sh "${CHECK_URL}" "/app/reports/${REPORT_NAME}" "${SLACK_URL}" "${SLACK_CHANNEL}"
fi

# S3に送信
if [ "${AWS_ACCESS_KEY_ID}" != "" ] && [ "${AWS_SECRET_ACCESS_KEY}" != "" ] && [ "${AWS_S3_BUCKET_PATH}" != "" ]; then
	if [ "${AWS_DEFAULT_REGION}" = "" ]; then
		AWS_DEFAULT_REGION="ap-northeast-1"
	fi
	aws s3 cp /app/reports/${REPORT_NAME}.report.html s3://${AWS_S3_BUCKET_PATH}/
fi

