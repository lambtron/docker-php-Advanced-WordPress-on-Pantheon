# Start with PHP and Terminus
FROM quay.io/pantheon-public/build-tools-ci:4.x

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