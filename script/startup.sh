#!/usr/bin/env bash


# =========== SIGTERM-handler ============
term_handler() {
    echo "term_handler trapped"
    # Stop Neo4j
    neo4j stop
    kill -s term ${api_pid}

    exit 143; # 128 + 15 -- SIGTERM
}

trap "term_handler" HUP INT QUIT TERM
#==============================================

echo "Institution is" ${INSTITUTION}
echo "Campus is" ${CAMPUS}

# Start Neo4j Instance
neo4j start
until curl -s -I http://localhost:7474 | grep -q "200 OK"
do
    sleep 5s
done

# Check if neo4j pwd needs to be initiated
if curl -u neo4j:neo4j  http://localhost:7474/user/neo4j/ | grep -q "\"password_change_required\" : true" ; then
    echo "Initiating Neo4j password"
    curl -u neo4j:neo4j -H "Content-Type: application/json" -X POST -d "{\"password\":\"${NEO4j_PWD}\"}" http://localhost:7474/user/neo4j/password
fi

# Ensure Institution name and Campus name for API in runtime
sed -i -e "s/^institution.name=.*$/institution.name=${INSTITUTION}/g" ${API_HOME}/application.properties
sed -i -e "s/^institution.campus=.*$/institution.campus=${CAMPUS}/g" ${API_HOME}/application.properties

#Start API
cd ${API_HOME}
java -jar *.war --spring.config.location=./application.properties:/overrides.properties & api_pid=$!


echo "Start Up Ending"
# Keep process alive
tail -f /dev/null & wait ${!}