FROM ubuntu:18.04 as builder

ARG TARGET_REPO=net.ton.dev

RUN apt-get update && apt-get install -y --no-install-recommends \
        sudo \
        ca-certificates \
        git \
        curl &&\
    mkdir -p "/opt/$TARGET_REPO" &&\
    git clone "https://github.com/tonlabs/$TARGET_REPO.git" "/opt/$TARGET_REPO" &&\
    cd "/opt/$TARGET_REPO/scripts" &&\
    sed -i 's/TON_WORK_DIR=".*"/TON_WORK_DIR="\/opt\/ton\/work"/g' env.sh &&\
    ./env.sh && ./build.sh 

FROM ubuntu:18.04

ARG TARGET_REPO=net.ton.dev

COPY --from=builder /opt/$TARGET_REPO /opt/$TARGET_REPO

WORKDIR "/opt/$TARGET_REPO/scripts"

COPY entrypoint.sh entrypoint.sh

RUN  chmod g+rwx -R "/opt" \ 
    && apt update \
    && apt install -y openssl curl libreadline-dev sudo net-tools vim cron\
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/ton/election && chmod g+rwx -R "/etc/ton" \
    && sed -i 's/ELECTIONS_WORK_DIR=".*"/ELECTIONS_WORK_DIR="\/etc\/ton\/election"/g' validator_msig.sh

ENV HOME /etc/ton

USER 99999:0

ENTRYPOINT ["./entrypoint.sh"]
