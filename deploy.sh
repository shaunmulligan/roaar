#!/bin/bash
set -e; set -o pipefail

# You will need to specify the avahi name of your resinOS on the local network.
rdt push --force-build -s . resin.local