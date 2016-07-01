#!/bin/bash

# ajustar o export de porta conforme o modelo adotado na infra

docker run \
        -d \
        -P \
        --name semead_app \
        --link semead_db:db \
        semead_app
