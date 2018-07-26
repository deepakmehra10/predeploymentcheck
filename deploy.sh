#!/bin/bash

#run cassandra script
./deployCassandraTables.sh 127.0.0.1 9042 cassandra cassandra

#run kassandra script
./deployKafkaConnectors.sh cloud-test aws-test
