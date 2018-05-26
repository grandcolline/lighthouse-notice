# lighthouse-notice

docker上でlighthouseを実行して、slackに通知＆S3にレポートを保存します。


## usage

TODO

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

