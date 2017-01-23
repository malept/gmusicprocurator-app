#!/bin/bash

if [[ "$TRAVIS_OS_NAME" = "linux" ]]; then
    sudo docker build -f ci/Dockerfile . -t gmusicprocurator-app
    sudo docker run -it gmusicprocurator-app make
else
    make
fi
