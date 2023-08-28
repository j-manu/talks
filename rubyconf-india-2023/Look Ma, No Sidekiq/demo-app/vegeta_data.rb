require "json"
require "csv"
require "time"

if ARGV.length != 1
  puts "Usage: ruby script_name.rb <filename_without_extension>"
  exit 1
end

filename = ARGV[0]

# Initialize variables
start_time = nil
elapsed_time = 0.0

# Create a CSV file and write elapsed time and latency columns
CSV.open("#{filename}.csv", "w") do |csv|
  csv << ["Time", "Latency"]

  # Read each line from the JSON file
  File.foreach("#{filename}.json") do |line|
    # Parse the JSON object in this line
    attack = JSON.parse(line.strip)

    # Parse the timestamp and calculate elapsed time
    timestamp = Time.parse(attack["timestamp"])
    start_time ||= timestamp  # Initialize start_time on the first iteration
    elapsed_time = (timestamp - start_time).to_i  # Elapsed time in milliseconds

    # Write elapsed time and latency to CSV
    csv << [elapsed_time, (attack["latency"] / 1000000).to_i]
  end
end
