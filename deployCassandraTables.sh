#!/usr/bin/env bash

#deploy cassandra
function deployCassandra() {

    if [ $# -ne 4 ]; then
        echo "insufficient arguments provided"
        exit 1
    fi

    directoryHome="./predeploymentcheck"
    hostName=$1
    portName=$2
    uname=$3a
    passwd=$4
    echo "host name: $hostName portName: $portName user: $uname passwrd: $passwd"

    readCassandraConfig
    export CASSANDRA_CONTACT_POINT_ONE=$cassandra_contact_point
    export PORT_NAME=$port
    echo "host name: $CASSANDRA_CONTACT_POINT_ONE port name : $PORT_NAME"

    if [ "$(ls -A db)" ]; then

        echo "db directory is not Empty"

        for file in `cd db && ls -A *.cql`; do
            echo "Executing Cassandra CQL File $file"
            $(cqlsh $hostName $portName -u $uname -p $passwd -f db/$file)
            if [ $? -eq 0 ]; then
                echo "$file deployed"
            else
                echo "$file cannot be deployed"
            fi

        done

    else
        echo "$directoryHome directory is empty"

    fi

}


#read cassandra config
readCassandraConfig() {
    cassandra_contact_point=$(jq '.["cloud-dev"].contactNodes[0]' config/cassandra-config.json)
    port=$(jq '.["cloud-dev"].contactPort' config/cassandra-config.json)
}

deployCassandra $1 $2 $3 $4
