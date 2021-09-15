FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y \
    locales \
    openssh-client \
    gnupg \
    git-crypt \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ENV TZ=Europe/Copenhagen

RUN mkdir -p /repo && mkdir /root/.ssh
WORKDIR /repo

COPY ssh/config /root/.ssh/config

COPY git-pull.sh /git-pull.sh
RUN chmod +x /git-pull.sh

CMD ["/git-pull.sh"]
