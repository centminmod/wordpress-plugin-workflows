#!/bin/bash

# Default values
WORKER_URL="$CF_SQL_WORKER_URL"
MODE="all"
DEBUG=0
START=1
END=0
PLUGINS=""
AUTH_USER=""
AUTH_PASS=""
CREATE_DB=0
RESET_DB=0
BATCH_SIZE=50
GET_COUNT=0
THREADS=1

# Function to display usage
usage() {
    echo "Usage: $0 [-u WORKER_URL] [-m MODE] [-p PLUGIN] [-b PLUGINS] [-s START] [-e END] [-d] [-c] [-r] [-U AUTH_USER] [-P AUTH_PASS] [-B BATCH_SIZE] [-C] [-t THREADS]"
    echo "  -u WORKER_URL : URL of the worker (default: $WORKER_URL)"
    echo "  -m MODE       : Mode (all, single, batch) (default: all)"
    echo "  -p PLUGIN     : Plugin slug for single mode"
    echo "  -b PLUGINS    : Comma-separated list of plugins for batch mode"
    echo "  -s START      : Start index for processing (default: 1)"
    echo "  -e END        : End index for processing (default: 0, meaning no limit)"
    echo "  -d            : Enable debug mode"
    echo "  -c            : Create database"
    echo "  -r            : Reset database"
    echo "  -U AUTH_USER  : Username for authentication"
    echo "  -P AUTH_PASS  : Password for authentication"
    echo "  -B BATCH_SIZE : Number of plugins to process in each batch (default: 50)"
    echo "  -C            : Get total plugin count"
    echo "  -t THREADS    : Number of concurrent threads (default: 1)"
    exit 1
}

# Parse command line arguments
while getopts "u:m:p:b:s:e:dcrU:P:B:Ct:" opt; do
    case ${opt} in
        u ) WORKER_URL=$OPTARG ;;
        m ) MODE=$OPTARG ;;
        p ) PLUGIN=$OPTARG ;;
        b ) PLUGINS=$OPTARG ;;
        s ) START=$OPTARG ;;
        e ) END=$OPTARG ;;
        d ) DEBUG=1 ;;
        c ) CREATE_DB=1 ;;
        r ) RESET_DB=1 ;;
        U ) AUTH_USER=$OPTARG ;;
        P ) AUTH_PASS=$OPTARG ;;
        B ) BATCH_SIZE=$OPTARG ;;
        C ) GET_COUNT=1 ;;
        t ) THREADS=$OPTARG ;;
        \? ) usage ;;
    esac
done

# Construct the URL based on the mode and options
construct_url() {
    local url="$WORKER_URL?mode=$MODE"
    
    if [ "$DEBUG" -eq 1 ]; then
        url+="&debug=1"
    fi
    
    case $MODE in
        single)
            if [ -z "$PLUGIN" ]; then
                echo "Error: Plugin slug is required for single mode."
                exit 1
            fi
            url+="&plugin=$PLUGIN"
            ;;
        batch)
            if [ -z "$PLUGINS" ]; then
                echo "Error: Comma-separated list of plugins is required for batch mode."
                exit 1
            fi
            url+="&plugins=$PLUGINS"
            ;;
        all)
            url+="&start=$1&end=$2&batchSize=$BATCH_SIZE"
            ;;
    esac
    
    echo "$url"
}

# Function to make request with optional authentication
make_request() {
    local url="$1"
    local curl_opts=(-s)
    
    if [ -n "$AUTH_USER" ] && [ -n "$AUTH_PASS" ]; then
        local auth_header="Authorization: Basic $(echo -n $AUTH_USER:$AUTH_PASS | base64)"
        curl_opts+=(-H "$auth_header")
    fi
    
    curl "${curl_opts[@]}" "$url"
}

# Function to check if authentication is required and provided
check_auth() {
    if [ "$CREATE_DB" -eq 1 ] || [ "$RESET_DB" -eq 1 ]; then
        if [ -z "$AUTH_USER" ] || [ -z "$AUTH_PASS" ]; then
            echo "Error: Authentication is required for database operations. Please provide -U and -P options."
            exit 1
        fi
    fi
}

# Function to get total plugin count
get_plugin_count() {
    local count_url="${WORKER_URL}?mode=count"
    local response=$(make_request "$count_url")
    echo "$response" | jq -r '.count'
}

# Function to process a batch of plugins
process_batch() {
    local start=$1
    local end=$2
    local url=$(construct_url $start $end)
    echo "Processing batch: $start to $end"
    echo "Making request to: $url"
    response=$(make_request "$url")
    echo "Response:"
    echo "$response" | jq .
}

# Function to process a single plugin
process_single() {
    local plugin=$1
    local url=$(construct_url)
    echo "Processing plugin: $plugin"
    echo "Making request to: $url"
    response=$(make_request "$url")
    echo "Response:"
    echo "$response" | jq .
}

# Function to process batches in a thread
process_thread() {
    local thread_start=$1
    local thread_end=$2
    local current_start=$thread_start

    while [ $current_start -le $thread_end ]; do
        local current_end=$((current_start + BATCH_SIZE - 1))
        if [ $current_end -gt $thread_end ]; then
            current_end=$thread_end
        fi

        process_batch $current_start $current_end

        current_start=$((current_end + 1))

        # Add a small delay between batches to avoid rate limiting
        sleep 2
    done
}

# Main execution
check_auth

if [ "$CREATE_DB" -eq 1 ]; then
    echo "Creating database..."
    make_request "${WORKER_URL}?createdb"
elif [ "$RESET_DB" -eq 1 ]; then
    echo "Resetting database..."
    make_request "${WORKER_URL}?resetdb"
elif [ "$GET_COUNT" -eq 1 ]; then
    count=$(get_plugin_count)
    echo "Total number of plugins: $count"
else
    case $MODE in
        single)
            process_single "$PLUGIN"
            ;;
        batch)
            process_batch 1 $(echo "$PLUGINS" | tr ',' '\n' | wc -l)
            ;;
        all)
            if [ "$END" -eq 0 ]; then
                total_count=$(get_plugin_count)
                END=$total_count
            fi

            plugins_per_thread=$(( (END - START + 1) / THREADS ))
            for ((i=0; i<THREADS; i++)); do
                thread_start=$((START + i * plugins_per_thread))
                thread_end=$((thread_start + plugins_per_thread - 1))
                if [ $i -eq $((THREADS - 1)) ]; then
                    thread_end=$END
                fi
                process_thread $thread_start $thread_end &
            done

            wait
            ;;
    esac
fi