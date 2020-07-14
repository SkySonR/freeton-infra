FROM ubuntu:18.04 as builder

ARG TARGET_REPO=net.ton.dev
ARG NETWORK_TYPE=game0

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
ARG

COPY --from=builder /opt/$TARGET_REPO /opt/$TARGET_REPO

WORKDIR "/opt/$TARGET_REPO/scripts"

COPY entrypoint.sh entrypoint.sh

RUN apt update \
    && apt install -y openssl curl libreadline-dev sudo net-tools vim cron traceroute python3-pip wget git inetutils-ping \
    && pip3 install psutil \
                    pyTelegramBotAPI \
                    python-dotenv \
                    matplotlib \
                    numpy \
                    pandas \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/anvme/TONTgBot.git /opt/tontgbot \
    && chmod +x /opt/tontgbot/installsbot.sh \
    && mkdir -p /etc/ton \
    && chmod g+rwx -R "/etc/ton" "/opt"

ENV HOME /etc/ton

USER 99999:0

ENTRYPOINT ["./entrypoint.sh"]
