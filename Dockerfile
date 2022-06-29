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
RUN useradd -ms /bin/bash git
USER git
RUN mkdir -p /home/git/repo && mkdir /home/git/.ssh
WORKDIR /home/git/repo

COPY ssh/config /home/git/.ssh/config

COPY git-pull.sh /home/git/git-pull.sh

CMD ["/home/git/git-pull.sh"]
