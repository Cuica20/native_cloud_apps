#!/bin/sh
echo "********************************************************"
echo "Waiting for the database server to start"              *"
echo "********************************************************"
while ! `nc -z database 5432`; do sleep 3; done
echo "******** Database Server has started"

echo "********************************************************"
echo "Waiting for the eureka server to start                 *"
echo "********************************************************"
while ! `nc -z eurekaserver 8761`; do sleep 3; done
echo "******* Eureka Server has started"

echo "********************************************************"
echo "Waiting for the configuration server to start"         *"
echo "********************************************************"
while ! `nc -z configserver 8888`; do sleep 3; done
echo "*******  Configuration Server has started"

echo "********************************************************"
echo "Sleeping for for 80 seconds.  This is to make sure that*"
echo "config is fully registered with the eureka.  This would*"
echo "not be a problem in a production env where the config  *"
echo "and discovery services would already be up and running.*"
echo "********************************************************"
sleep 200

echo "********************************************************"
echo "Starting Organization Service with Configuration Service via Eureka :  $EUREKASERVER_URI on PORT: $SERVER_PORT";
echo "********************************************************"
java -Djava.security.egd=file:/dev/./urandom -Dserver.port=$SERVER_PORT -Deureka.client.serviceUrl.defaultZone=$EUREKASERVER_URI -Dspring.profiles.active=$PROFILE -jar /usr/local/organizationservice/organization-service-0.0.1-SNAPSHOT.jar
