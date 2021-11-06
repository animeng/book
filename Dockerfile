e an official Node.js runtime as a parent image
FROM node:14.5.0
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
USER root
WORKDIR /home/book
COPY . /home/book
# Set npm registry to China Taobao and install Gitbook
RUN npm config set registry https://registry.npm.taobao.org && \
    npm install gitbook-cli -g && \
    gitbook -V && \
    npm install graceful-fs@4.2.0 --save

EXPOSE 9998

CMD ["sh", "-c", "gitbook install /gitbook; gitbook serve /gitbook"]
