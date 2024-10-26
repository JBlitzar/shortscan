#!/bin/bash

# Function to generate a random string of 5 alphanumeric characters
generate_random_code() {
   LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 5; echo

}
# for i in {1..5}; do
#         echo "$(generate_random_code)"
#     done

# Function to perform HEAD request and follow redirects
check_url() {
    local short_url="https://shorturl.at/$(generate_random_code)"

    # Perform a HEAD request with limited redirects and timeout
    final_url=$(curl -sIL -o /dev/null -w '%{url_effective}' --connect-timeout 5 --max-redirs 3 "$short_url")

    # If the final URL does not contain "shorturl.at", print it
    if [[ "$final_url" != *"shorturl.at"* ]]; then
        echo "Redirected URL: $final_url"
    fi
}


run_batch() {
    for i in {1..5}; do
        check_url
    done

    wait
}


num_batches=50


for (( batch=1; batch<=num_batches; batch++ )); do
    echo "Running batch $batch..."
    run_batch
done
