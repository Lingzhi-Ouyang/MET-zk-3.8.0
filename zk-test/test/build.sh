#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "$0") || exit;pwd)
WORKING_DIR=$(cd "$SCRIPT_DIR"/../.. || exit;pwd)

# build
echo -e "\n>> Building project...\n"
cd "$WORKING_DIR"/zk-test && mvn clean install -DskipTests
echo "Done!"