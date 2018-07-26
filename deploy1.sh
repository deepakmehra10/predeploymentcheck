#!/bin/bash

deployKafkaConnectors() {

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi

    echo "Kafka connector deployment in progress"

    directoryHome="./kafkaconnectors"
    environment=$1
    kafkaBroker=$(jq -r ".[\"$environment\"].kafkaConnectUrl" ./config/kafka-config.json)
    echo "Kafka Broker - $kafkaBroker"
    #for config in "ls -A"

    fullurl=$kafkaBroker/connectors
    echo "$fullurl"

    if [ "$(ls -A $directoryHome)" ]; then

        echo "$directoryHome directory is not Empty"


        for connector in $(cd "$directoryHome"/"$2" && ls -A *.json); do

            echo "Connector Name"
            status=$(curl -o -I -L -s -w "%{http_code}" -d @"./kafkaconnectors/$2/$connector" -H "Content-Type: application/json" -X POST "$kafkaBroker"/connectors)

            echo "Status $status"
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

        done

    else
        echo "$directoryHome directory is empty"
    fi

}

deployKafkaConnectors "$1" "$2"
