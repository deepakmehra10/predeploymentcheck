#!/usr/bin/env bash

deploy_kafka_connectors() {

if [ $# -ne 2 ]; then
    echo "insufficient arguments provided"
    exit 1
fi

    echo "Kafka connector deployment in progress"

    directory_home="./kafkaconnectors"
    environment=$1
    kafka_connect_url=$(jq -r ".[\"$environment\"].kafkaConnectUrl" ./config/kafka-config.json)
    echo "Kafka Broker - $kafka_connect_url"

    fullurl=$kafka_connect_url/connectors
    echo "$fullurl"

    if [ "$(ls -A ${directory_home})" ]; then

        echo "$directory_home directory is not Empty"


        for connector in $(cd "$directory_home"/"$2" && ls -A *.json); do

            echo "Connector Name"
            status=$(curl -o -I -L -s -w "%{http_code}" -d @"./kafkaconnectors/$2/$connector" -H "Content-Type: application/json" -X POST "$kafka_connect_url"/connectors)

            if [ $? -eq 0 ]; then

            if [ "$status" -eq 201 ]
            then
                echo "Connector $connector deployed successfully on $environment."

            elif [ "$status" -eq 409 ]
            then
                echo "Connector $connector could not be deployed on $environment."
                echo "Status is not OK + $status, Connectors already exists please check."

            else
                echo "Something is wrong, please verify again."
            fi

                else
                echo "$file cannot be deployed"
                fi

        done

    else
        echo "db directory is empty"
    fi

}

deploy_kafka_connectors $1 $2
