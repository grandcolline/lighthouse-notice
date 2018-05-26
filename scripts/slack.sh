#!/bin/sh

# -------------------------
# slack通知する関数
# Arguments:
#   $1 調査するURL
#   $2 レポートのパス
#   $3 slack incomming-webhook URL
#   $4 slack チャンネル名
# -------------------------

# configセット
url="${1}"
report="${2}"
slack_url="${3}"
slack_channel="${4}"

# emoji返却関数
emoji () {
	if [ ${1} -le 30 ] ; then
		echo "${1} :scream:"
	elif [ ${1} -ge 90 ] ; then
		echo "${1} :beers:"
	elif [ ${1} -ge 80 ] ; then
		echo "${1} :+1:"
	elif [ ${1} -ge 70 ] ; then
		echo "${1} :blush:"
	else
		echo "${1}"
	fi
}

# データ取得
performance=$( \
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Performance") | .score' | \
	awk '{printf("%d",$1)}' \
)
pwa=$( \
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Progressive Web App") | .score' | \
	awk '{printf("%d",$1)}' \
)
accessibility=$( \
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Accessibility") | .score' | \
	awk '{printf("%d",$1)}' \
)
best_practices=$( \
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Best Practices") | .score' | \
	awk '{printf("%d",$1)}' \
)
seo=$( \
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "SEO") | .score' | \
	awk '{printf("%d",$1)}' \
)
time_to_first_byte=$( \
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Performance") | .audits[] | select ( .id == "time-to-first-byte" ) | .result.rawValue' | \
	awk '{printf("%d",$1)}' \
)
first_meaningful_paint=$(
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Performance") | .audits[] | select ( .id == "first-meaningful-paint" ) | .result.rawValue' | \
	awk '{printf("%d",$1)}' \
)
first_interactive=$(
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Performance") | .audits[] | select ( .id == "first-interactive" ) | .result.rawValue' | \
	awk '{printf("%d",$1)}' \
)
consistently_interactive=$(
	cat ${report}.report.json | \
	jq '.reportCategories[] | select ( .name == "Performance") | .audits[] | select ( .id == "consistently-interactive" ) | .result.rawValue' | \
	awk '{printf("%d",$1)}' \
)

# payload作成
payload="payload={
\"channel\": \"${slack_channel}\",
\"username\": \"lighthouse-notice\",
\"icon_emoji\": \":lighthouse:\",
\"text\": \"CHECK_URL: ${url}\",
\"attachments\": [
	{
		\"title\": \"====== Site Score ======\",
		\"color\": \"good\",
		\"fields\": [
			{
				\"title\": \"Performance\",
				\"value\": \"`emoji ${performance}`\",
				\"short\": true
			},
			{
				\"title\": \"Progressive Web App\",
				\"value\": \"`emoji ${pwa}`\",
				\"short\": true
			},
			{
				\"title\": \"Accessibility\",
				\"value\": \"`emoji ${accessibility}`\",
				\"short\": true
			},
			{
				\"title\": \"Best Practices\",
				\"value\": \"`emoji ${best_practices}`\",
				\"short\": true
			},
			{
				\"title\": \"SEO\",
				\"value\": \"`emoji ${seo}`\",
				\"short\": true
			}
		]
	},
	{
		\"title\": \"====== Site Speed ======\",
		\"color\": \"good\",
		\"fields\": [
			{
				\"title\": \"Time To First Byte\",
				\"value\": \"${time_to_first_byte}ms\",
				\"short\": true
			},
			{
				\"title\": \"First Meaningful Paint\",
				\"value\": \"${first_meaningful_paint}ms\",
				\"short\": true
			},
			{
				\"title\": \"First Interactive\",
				\"value\": \"${first_interactive}ms\",
				\"short\": true
			},
			{
				\"title\": \"Consistently Interactive\",
				\"value\": \"${consistently_interactive}ms\",
				\"short\": true
			}
		]
	}
]
}"

# 送信
curl -sSX POST -m 5 --data-urlencode "${payload}" "${slack_url}"

