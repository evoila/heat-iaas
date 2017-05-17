#!/bin/sh

for FILE in \
  network/ipv4.yaml \
  volume/basic.yaml \
  instance/basic.yaml \
  instance/random_name.yaml \
  instance/load_balanced.yaml \
  misc/jumphost.yaml \
  cluster/networking/frontend_backend.yaml \
  cluster/networking/simple.yaml \
  cluster/basic.yaml \
  cluster/load_balanced.yaml \
  cluster/auto_scaling.yaml \
  cluster/load_balanced_auto_scaling.yaml \
  ; do

  TEST=$(echo $FILE | sed 's/\//_/g' | sed 's/.yaml$//')

  echo "$TEST: Start"

  CMD="openstack --insecure stack create --wait --enable-rollback \
-t $FILE -e ../library.yaml \
--parameter key=$STACK_KEY \
--parameter image=$STACK_IMAGE \
--parameter public_network=$STACK_PUBLICNETWORK \
--parameter flavor=$STACK_FLAVOR \
--parameter dns_nameservers=$STACK_DNSSERVERS \
$TEST"

  echo "$TEST: $CMD"

  OUTPUT=$($CMD)
  RESULT=$?

  if [ $RESULT -gt 0 ]; then
    echo -n "$TEST: Failed with exit code $RESULT:\n$OUTPUT"
    exit 1
  fi

  echo "$TEST: Successfully deployed"

  echo "$TEST: Cleanup"
  OUTPUT=$(openstack --insecure stack delete --yes --wait $TEST)
  RESULT=$?

  if [ $RESULT -gt 0 ]; then
    echo -n "$TEST: Cleanup failed with exit code $RESULT:\n$OUTPUT"
    exit 1
  fi

  echo "$TEST: Successfully cleaned up"

done
