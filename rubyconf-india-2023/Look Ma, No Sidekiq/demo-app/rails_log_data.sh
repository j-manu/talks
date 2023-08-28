#!/bin/bash

# Check if a filename is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <CSV Filename without extension>"
  exit 1
fi

# Initialize the CSV filename
CSV_FILENAME="$1-log.csv"

# Write the header of the CSV file
echo "Time,Duration" > "results/$CSV_FILENAME"

# Initialize the first timestamp
first_time=""

# Process the log file and append data to the CSV file
awk '
  BEGIN {
    first_time = "";
  }
  /INFO -- :/ {
    duration = "N/A";  # Initialize variables to "N/A"
    time = "N/A";

    for(i=1; i<=NF; i++) {
      # Extract the duration
      if ($i ~ /^duration=/) {
        split($i, arr, "=");
        duration = arr[2];
      }

      # Extract the time
      if ($i ~ /^time=/) {
        split($i, arr, "=");
        time = arr[2];
      }
    }

    # Capture the first timestamp if not set
    if (first_time == "") {
      first_time = time;
    }

    # Calculate elapsed time in seconds
    elapsed_seconds = time - first_time;

    print elapsed_seconds "," duration;
  }
' log/production.log >> "results/$CSV_FILENAME"

echo "Extraction complete. Data saved in results/$CSV_FILENAME."
