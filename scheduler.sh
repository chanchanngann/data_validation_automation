#!/bin/bash
# author: Rachel Chan
# created on 20240218
# description: run "run_validation.sh" every 3 mins
# script usage: need to have run_validation.sh in the same folder

echo "run validation..."

while true; do ./run_validation.sh ; sleep 180 ; done &

exit 0