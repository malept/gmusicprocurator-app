FROM malept/electron-forge-container:latest

ENV CI=true

RUN apt install --no-install-recommends -y librsvg2-bin icoutils icnsutils && \
    rm -r /var/cache/apt/archives

RUN mkdir /code
WORKDIR /code
ADD . /code/
