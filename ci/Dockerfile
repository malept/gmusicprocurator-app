FROM malept/electron-forge-container:latest

RUN apt install -y icoutils icnsutils && \
    rm -r /var/cache/apt/archives

RUN flatpak remote-add --from gnome https://sdk.gnome.org/gnome.flatpakrepo && \
    flatpak install --runtime gnome org.freedesktop.Platform//1.4

RUN mkdir /code
WORKDIR /code
ADD . /code/
