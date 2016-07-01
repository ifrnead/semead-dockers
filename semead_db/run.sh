#!/bin/bash
docker run \
        -d \
        --name semead_db \
        -e MYSQL_USER=semead_user \
        -e MYSQL_PASSWORD=semead_password \
        -e MYSQL_DATABASE=semead_db \
        semead_db
