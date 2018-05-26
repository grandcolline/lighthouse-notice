# lighthouse-notice

docker上でlighthouseを実行して、slackに通知＆S3にレポートを保存します。

## Docker Image

[grandcolline/lighthouse-notice](https://hub.docker.com/r/grandcolline/lighthouse-notice/)

## Usage

sample
```
docker run --rm \
	-e "CHECK_URL=https://example.com" \
	-e "SLACK_URL=https://hooks.slack.com/services/XXXXX/XXXXX/XXXXX" \
	-e "SLACK_CHANNEL=#channel_name" \
	-e "AWS_ACCESS_KEY_ID=AKIXXXXXX" \
	-e "AWS_SECRET_ACCESS_KEY=XXXXXXXX" \
	-e "AWS_S3_BUCKET_PATH=example-bucket" \
	-t -i grandcolline/lighthouse
```

## Environment Variables

|Name|Required||
|:-:|:-:|:-|
|`CHECK_URL`|*|lighthouseで調査するURL|
|`REPORT_NAME`||レポートの名前。未入力の場合`date "+%Y%m%d%H%M"`|
|`SLACK_URL`||slackのincomming-webhookのURL|
|`SLACK_CHANNEL`||slack通知するチャンネル名|
|`AWS_ACCESS_KEY_ID`|||
|`AWS_SECRET_ACCESS_KEY`|||
|`AWS_DEFAULT_REGION`||未入力の場合`ap-northeast-1`|
|`AWS_S3_BUCKET_PATH`|||

## preview

![slack-notice](https://github.com/grandcolline/lighthouse-notice/blob/images/slack-notice.png)

