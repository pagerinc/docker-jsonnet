#!/bin/ash

set -o errexit
set -o nounset

apk --no-cache add bats

echo "Unit Tests..."

bats /tmp/test

echo "#############"
echo "# Tests OK! #"
echo "#############"
