#!/bin/bash

set -o errexit
set -o nounset

apt-get update && apt-get install --no-install-recommends -y bats

echo "Unit Tests..."

bats /tmp/test

echo "#############"
echo "# Tests OK! #"
echo "#############"
