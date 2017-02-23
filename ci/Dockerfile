FROM malept/electron-forge-container:latest

ENV CI=true

RUN dpkg --add-architecture armhf && \
    dpkg --add-architecture i386 && \
    apt update && \
    apt install --no-install-recommends -y libavahi-compat-libdnssd-dev:i386 libavahi-compat-libdnssd-dev:armhf
RUN apt install --no-install-recommends -y librsvg2-bin icoutils icnsutils && \
    rm -r /var/cache/apt/archives

RUN mkdir /code
WORKDIR /code
ADD . /code/
