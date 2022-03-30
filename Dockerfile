FROM alpine:3.15.3

RUN apk --no-cache add \
    bash \
    git \
    git-lfs \ 
    tzdata

ENV TZ=Europe/Copenhagen

ENV BRANCH master
ENV URL null

RUN mkdir -p /repo
WORKDIR /repo

COPY git-pull.sh /git-pull.sh
RUN chmod +x /git-pull.sh

CMD ["/git-pull.sh"]