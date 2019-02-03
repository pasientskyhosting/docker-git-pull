FROM alpine:latest

RUN apk --no-cache add \
    bash \
    git \
    openssh-client \
    git-lfs \ 
    tzdata \
    && mkdir -p /root/.ssh

ENV TZ=Europe/Copenhagen

ENV BRANCH master
ENV URL null

RUN mkdir -p /repo
WORKDIR /repo

RUN echo -e "Host github.com\n     IdentityFile /root/.ssh/id_rsa\n     IdentitiesOnly yes\n     StrictHostKeyChecking No" > /root/.ssh/config

COPY git-pull.sh /git-pull.sh
RUN chmod +x /git-pull.sh

CMD ["/git-pull.sh"]