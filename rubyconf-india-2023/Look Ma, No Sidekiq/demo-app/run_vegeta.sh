#!/bin/bash

FILENAME=""
DURATION=""
MAX_WORKERS="20"
TARGETS_FILE=""
PID=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --filename)
      FILENAME="$2"
      shift 2
      ;;
    --duration)
      DURATION="$2"
      shift 2
      ;;
    --targets-file)
      TARGETS_FILE="$2"
      shift 2
      ;;
    --pid)
      PID="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

if [ -z "$FILENAME" ] || [ -z "$DURATION" ] || [ -z "$TARGETS_FILE" ] || [ -z "$PID" ]; then
  echo "Usage: $0 --filename <filename> --duration <duration>  --targets-file <targets-file> --pid <PID>"
  exit 1
fi

FINAL_FILENAME="${FILENAME}-duration-${DURATION}s-${TARGETS_FILE}"

VEGETA_DURATION="${DURATION}s"

COLLECT_STATS_DURATION=$(($DURATION + 2))

COLLECT_STATS_FILENAME="${FINAL_FILENAME}-cpu"

VEGETA_FILENAME="${FINAL_FILENAME}.bin"

./collect_stats.sh $COLLECT_STATS_FILENAME $PID $COLLECT_STATS_DURATION &

echo "" > log/production.log

vegeta -cpus 1 attack -rate 10 -duration $VEGETA_DURATION -targets $TARGETS_FILE | tee results/$VEGETA_FILENAME | vegeta report

echo "Attack and data collection complete. Results saved in $FINAL_FILENAME."

./rails_log_data.sh $FINAL_FILENAME

cat results/$VEGETA_FILENAME | vegeta encode | jq -c '{timestamp: .timestamp, latency: .latency, code: .code}' > results/$FINAL_FILENAME.json

ruby vegeta_data.rb results/$FINAL_FILENAME

echo "Done"
