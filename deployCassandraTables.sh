#!/usr/bin/env bash

#deploy cassandra
function create_cassandra_tables() {

    if [ $# -ne 4 ]; then
        echo "insufficient arguments provided"
        exit 1
    fi

    directory_home="./predeploymentcheck"
    host_name=$1
    port_name=$2
    username=$3a
    password=$4
    echo "host name: $host_name portName: $port_name user: $username passwrd: $password"

    read_cassandra_config

    export CASSANDRA_CONTACT_POINT_ONE=$cassandra_contact_point
    export PORT_NAME=$port
    echo "host name: $CASSANDRA_CONTACT_POINT_ONE port name : $PORT_NAME"

    if [ "$(ls -A db)" ]; then

        echo "db directory is not Empty"

        for file in `cd db && ls -A *.cql`; do
            echo "Executing Cassandra CQL File $file"
            $(cqlsh ${host_name} ${port_name} -u ${username} -p ${password} -f db/${file})
            if [ $? -eq 0 ]; then
                echo "$file deployed"
            else
                echo "$file cannot be deployed"
            fi

        done

    else
        echo "$directory_home directory is empty"

    fi

}


#read cassandra config
function read_cassandra_config() {
    cassandra_contact_point=$(jq '.["cloud-dev"].contactNodes[0]' config/cassandra-config.json)
    port=$(jq '.["cloud-dev"].contactPort' config/cassandra-config.json)
}

create_cassandra_tables $1 $2 $3 $4
