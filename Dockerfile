FROM node:9
MAINTAINER hayashitaiki<grandcolline@gmail.com>

USER root

# timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# For npm install
ARG CACHEBUST=1

# install utils
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		jq \
		npm \
	&& apt-get clean

# yarm
RUN npm --global install yarn

# google-chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
	echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
	apt-get update && \
	apt-get install -y --no-install-recommends google-chrome-stable && \
	groupadd -r chrome && \
	useradd -r -g chrome -G audio,video chrome && \
	mkdir -p /home/chrome && chown -R chrome:chrome /home/chrome

# lighthouse 
RUN yarn global add lighthouse

# AWS CLI
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		python \
		python-dev \
		python-pip \
		python-setuptools \
		groff \
		less \
	&& pip install --upgrade awscli \
	&& apt-get clean

RUN mkdir -p /app/reports
VOLUME /app/reports

ADD . /app

WORKDIR /app

CMD [ "./scripts/startup.sh" ]

