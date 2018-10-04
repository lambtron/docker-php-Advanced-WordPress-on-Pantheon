# Start with PHP 7.2
FROM drupalci/php-7.2-apache:production

# Update
RUN apt-get update 

# Install wget
RUN \
	echo -e "\nInstalling wget..." && \
	apt-get install -y wget

# Install openssl
RUN \
	echo -e "\nInstalling openssl..." && \
	apt-get install -y openssl

# Install rsync
RUN \
	echo -e "\nInstalling rsync..." && \
	apt-get install -y rsync

# Install jq
RUN \
	echo -e "\nInstalling jq..." && \
	apt-get install -y jq

# Install ssh
RUN \
	echo -e "\nInstalling ssh..." && \
	apt-get install -y openssh-client

# Install Terminus
RUN \
	echo -e "\nInstalling Terminus 1.x..." && \
	/usr/bin/env COMPOSER_BIN_DIR=$HOME/bin composer --working-dir=$HOME require pantheon-systems/terminus "^1"

# Enable Composer parallel downloads
RUN \
	echo -e "\nInstalling hirak/prestissimo for parallel Composer downloads..." && \
	composer global require -n "hirak/prestissimo:^0.3"

# Install Terminus plugins
RUN \
	echo -e "\nInstalling Terminus plugins..." && \
	mkdir -p $HOME/.terminus/plugins && \
	composer create-project -n -d $HOME/.terminus/plugins pantheon-systems/terminus-build-tools-plugin:dev-master && \
	composer create-project -n -d $HOME/.terminus/plugins pantheon-systems/terminus-secrets-plugin:^1

# Headless Chrome
# See https://github.com/GoogleChrome/puppeteer/blob/master/docs/troubleshooting.md#running-puppeteer-in-docker

# See https://crbug.com/795759
RUN apt-get update && apt-get install -yq libgconf-2-4

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-unstable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge --auto-remove -y curl \
    && rm -rf /src/*.deb

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["dumb-init", "--"]
CMD ["google-chrome-unstable"]
