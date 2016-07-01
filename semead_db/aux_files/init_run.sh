#!/bin/bash

if [ -z "$MYSQL_INITIALIZED" ]; then

    # Demands the necessary variables
    if [ -z "$MYSQL_USER" ]; then
        echo >&2 'ERROR: database is uninitialized and MYSQL_USER not set'
        echo >&2 '  Did you forget to add -e MYSQL_USER=... ?'
        exit 1
    fi
    if [ -z "$MYSQL_PASSWORD" ]; then
        echo >&2 'ERROR: database is uninitialized and MYSQL_PASSWORD not set'
        echo >&2 '  Did you forget to add -e MYSQL_PASSWORD=... ?'
        exit 1
    fi
    if [ -z "$MYSQL_DATABASE" ]; then
        echo >&2 'ERROR: database is uninitialized and MYSQL_DATABASE not set'
        echo >&2 '  Did you forget to add -e MYSQL_DATABASE=... ?'
        exit 1
    fi

    # Start mysql service temporarily
    service mysql start

    # Waits a few seconds before its starts
    for sec in 1 2 3 4 5 6 7 8 9 10; do
        sleep 1
    done

    # Get random mysql's root password
    MYSQL_ROOT_PASSWORD=`head -c 20 /dev/random | base64 | head -c 15`
    echo $MYSQL_ROOT_PASSWORD > /etc/container_environment/MYSQL_ROOT_PASSWORD

    # Sets the mysql's root passwordi
    if [ "$MYSQL_ROOT_PASSWORD" ]; then

        mysql -u root -e "
            SET @@SESSION.SQL_LOG_BIN=0;
            DELETE FROM mysql.user WHERE user LIKE 'root';
            CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
            GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
            DROP DATABASE IF EXISTS test;
            FLUSH PRIVILEGES;
            "

        if [ $? -ne 0 ]; then
            echo >&2 'ERROR: mysql root password was not setted'
            exit 1
        fi

    fi

    # Create the database
    if [ "$MYSQL_DATABASE" ]; then

        mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "
            CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
            "

        if [ $? -ne 0 ]; then
            echo >&2 'ERROR: database is uninitialized and the daemon was not started'
            exit 1
        fi

    fi

    # Create username and password
    if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then

        mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "
            CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
            GRANT ALL ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
            FLUSH PRIVILEGES;
            "

        if [ $? -ne 0 ]; then
            echo >&2 'ERROR: username or password is uninitialized and the daemon was not started'
            exit 1
        fi

    fi

    # Stops mysql service
    service mysql stop

    # Consider yourself as initialized
    echo "true" > /etc/container_environment/MYSQL_INITIALIZED

fi
