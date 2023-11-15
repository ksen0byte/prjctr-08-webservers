#!/bin/bash

IMAGE1_URL="http://localhost/images/1.png"
IMAGE2_URL="http://localhost/images/2.png"
PURGE_URL="http://localhost/purge/images/1.png"

# Function to make a request and print the cache status
make_request() {
    local url=$1
    echo "Requesting $url"
    RESPONSE=$(curl -s -I $url)
    HTTP_CODE=$(echo "$RESPONSE" | grep HTTP | awk '{print $2}')
    CACHE_STATUS=$(echo "$RESPONSE" | grep X-Cache-Status | awk '{print $2}')
    echo -e "HTTP Code: $HTTP_CODE | Cache Status: $CACHE_STATUS\n"
}

# Function to purge cache
purge_cache() {
    echo "Purging cache for $IMAGE1_URL"
    curl -s -o /dev/null -X GET $PURGE_URL
    echo -e "Cache purged for $IMAGE1_URL.\n"
}

echo "=== NGINX Cache Behavior Demonstration ==="

# Request Image 1 - cache should be MISS initially
make_request $IMAGE1_URL

# Request Image 2 - to demonstrate independent caching
make_request $IMAGE2_URL

# Second request for Image 1 - cache should still be MISS
make_request $IMAGE1_URL

# Second request for Image 2 - cache should still be MISS
make_request $IMAGE2_URL

# Third request for Image 1 - cache should be HIT
make_request $IMAGE1_URL

# Purging the cache for Image 1
purge_cache

# After purging, cache for Image 1 should be MISS again
make_request $IMAGE1_URL

# Request Image 2 again - to demonstrate its cache is unaffected
make_request $IMAGE2_URL

echo "=== Demonstration Complete ==="
