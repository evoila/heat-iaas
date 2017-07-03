#!/bin/bash

KEY_NAME=$1
ENVIRONMENT=$2

for TEST in `find tests -type f`; do
  NAME=$(echo $TEST | gsed 's/tests\///g' | gsed 's/\//_/g' | gsed 's/.yaml$//g')
  echo "TEST[$NAME]"
  openstack stack create\
    -t $TEST\
    -e resources.yaml\
    -e env/${ENVIRONMENT}.yaml\
    --parameter key=$KEY_NAME\
    --wait\
    test-$NAME 2>&1
done
