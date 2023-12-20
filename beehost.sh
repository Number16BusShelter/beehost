#!/bin/bash

# Default values
http_ports="80"
https_ports="443,9443"
output_dir="./ffuf_vhost"
ip_file="./ips.txt"
vhosts_file="./vhosts.txt"
final_result_file="${output_dir}/final_results.txt"

# Function to display script usage
display_help() {
  echo "Usage: $0 [-h] [-p ports] [-P http_ports] [-o output_dir] [-i ip_file] [-v vhosts_file]"
  echo "Options:"
  echo "  -h                 Display this help message"
  echo "  -p ports           Specify ports for HTTPS (comma-separated)"
  echo "  -P http_ports      Specify ports for HTTP (comma-separated)"
  echo "  -o output_dir      Specify the output directory"
  echo "  -i ip_file         Specify the location of the IP file"
  echo "  -v vhosts_file     Specify the location of the vhosts file"
  exit 1
}

# Function to handle cleanup before exit
cleanup() {
  echo "Cleaning up..."
  # Add any cleanup actions here, if needed
  exit 1
}

# Trap Ctrl+C signal
trap cleanup SIGINT


# Check if ip_file and vhosts_file exist
check_file_exists() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "Error: File $file not found."
    cleanup
  fi
}


# Parse command-line options
while getopts ":hp:P:o:i:v:" opt; do
  case ${opt} in
    h)
      display_help
      ;;
    p)
      https_ports="${OPTARG}"
      ;;
    P)
      http_ports="${OPTARG}"
      ;;
    o)
      output_dir="${OPTARG}"
      ;;
    i)
      ip_file="${OPTARG}"
      ;;
    v)
      vhosts_file="${OPTARG}"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      display_help
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      display_help
      ;;
  esac
done
# Check if ip_file and vhosts_file exist
check_file_exists "$ip_file"
check_file_exists "$vhosts_file"

mkdir -p "${output_dir}"


parse_and_format_json() {
  local json_file="$1"
  local result_file="$2"

  jq -r '. | "code: \(.status), url: \(.url), host: \(.host), length: \(.length), words: \(.words), lines: \(.lines), content-type: \(.["content-type"]), redirect: \(.redirectlocation)"' "${json_file}" >> "${result_file}"
}

run_ffuf() {
  local protocol="$1"
  local port="$2"
  local ip="$3"
  local output_file_temp="${output_dir}/${ip}_${protocol}_${port}_temp_results.txt"

  echo "Testing ${protocol}://${ip}":"${port}/..."

  # Check if the host and port respond before running FFUF
  if nc -z -w 1 "${ip}" "${port}"; then
    ffuf -timeout 10 -fc 400,404 \
      -w "${vhosts_file}:VHOST" \
      -u "${protocol}://${ip}:${port}/" \
      -mc all \
      -H "Host: VHOST" \
      --json >> "${output_file_temp}"

    parse_and_format_json "${output_file_temp}" "${output_dir}/${ip}_results.txt"
    rm "${output_file_temp}"
  else
    echo "Host and port with ${protocol}://${ip}:${port} did not respond. Skipping..."
  fi
}


echo "Script started..."

# Loop through each IP in the ips.txt file
while IFS= read -r ip; do
  for protocol in "http" "https"; do
    for port in $(echo ${http_ports} ${https_ports} | tr ',' ' '); do
      run_ffuf "${protocol}" "${port}" "${ip}"
    done
  done
done < "${ip_file}"


# Concatenate all temporary result files into a single result file and remove duplicates
cat "${output_dir}"/*_results.txt | sort | uniq > "${final_result_file}"

echo "Script completed."
cleanup
