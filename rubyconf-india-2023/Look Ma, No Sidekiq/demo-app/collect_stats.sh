#!/bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <filename> <PID> <seconds>"
  exit 1
fi

FILENAME="$1.csv"
PID="$2"
SECONDS_TO_RUN="$3"

SECONDS=0

echo "time,cpu,memory" > results/$FILENAME

while [ $SECONDS -lt $SECONDS_TO_RUN ]; do
  top -pid $PID -l 3 -stats cpu,mem | tail -n 1 | awk -v now=$SECONDS 'BEGIN {OFS=","} {print now,$1,$2}' >> results/$FILENAME
done

echo "Data collection complete. Results saved in results/$FILENAME."
