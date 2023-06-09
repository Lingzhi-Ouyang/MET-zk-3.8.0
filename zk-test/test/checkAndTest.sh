#!/bin/bash

## kill current running zookeeper processes
ps -ef | grep zookeeper | grep -v grep | awk '{print $2}' | xargs kill -9

SCRIPT_DIR=$(cd $(dirname "$0") || exit;pwd)
WORKING_DIR=$(cd "$SCRIPT_DIR"/../.. || exit;pwd)
echo "## Working directory: $WORKING_DIR"

echo -e "\n==========Model level=========="
cd "$WORKING_DIR"/zk-test/test/generator || exit
./run.sh

echo -e "\n==========Code level=========="
cd "$WORKING_DIR"/zk-test/test || exit

echo -e "\n>> Configuring test case directory..."
TARGET_DIR=$(ls -dt traces/*_output | head -1)
sed -i -e "s|^traceDir =.*|traceDir = ${TARGET_DIR}|g" zookeeper.properties
echo "## Test case directory: ${TARGET_DIR}"

echo -e "\n>> Setting output directory..."
tag=$(date "+%y-%m-%d-%H-%M-%S")
REPLAY_DIR="${TARGET_DIR}_replay_${tag}"
mkdir -p "${REPLAY_DIR}"
cp zk_log.properties "${REPLAY_DIR}"
echo "## Output directory: ${REPLAY_DIR}"

echo -e "\n>> Running test...\n"
JAVA_VERSION=$(java -version 2>&1 |awk -F '[".]+' 'NR==1{ print $2 }')
if [[ $JAVA_VERSION -le 8 ]]; then
  nohup java -ea -jar ../zookeeper-ensemble/target/zookeeper-ensemble-jar-with-dependencies.jar zookeeper.properties ${REPLAY_DIR} > ${REPLAY_DIR}/${tag}.out 2>&1 &
else
  nohup java -ea --add-opens=java.base/java.lang=ALL-UNNAMED -jar ../zookeeper-ensemble/target/zookeeper-ensemble-jar-with-dependencies.jar zookeeper.properties ${REPLAY_DIR} > ${REPLAY_DIR}/${tag}.out 2>&1 &
fi