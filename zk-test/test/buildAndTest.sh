#!/bin/bash

## kill current running zookeeper processes
ps -ef | grep zookeeper | grep -v grep | awk '{print $2}' | xargs kill -9

SCRIPT_DIR=$(cd $(dirname "$0") || exit;pwd)
WORKING_DIR=$(cd "$SCRIPT_DIR"/../.. || exit;pwd)

echo "Working directory: $WORKING_DIR"

# build
cd "$WORKING_DIR"/zk-test && mvn clean install -DskipTests

# run tests
cd "$WORKING_DIR"/zk-test/test || exit
tag=$(date "+%y-%m-%d-%H-%M-%S")
mkdir $tag
echo "Output directory: $(pwd)/$tag"
cp zk_log.properties $tag

JAVA_VERSION=$(java -version 2>&1 |awk -F '[".]+' 'NR==1{ print $2 }')
if [[ $JAVA_VERSION -le 8 ]]; then
  # enable assertions!
  nohup java -ea -jar ../zookeeper-ensemble/target/zookeeper-ensemble-jar-with-dependencies.jar zookeeper.properties $tag > $tag/$tag.out 2>&1 &
else
  nohup java -ea --add-opens=java.base/java.lang=ALL-UNNAMED -jar ../zookeeper-ensemble/target/zookeeper-ensemble-jar-with-dependencies.jar zookeeper.properties $tag > $tag/$tag.out 2>&1 &
fi