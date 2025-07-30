#!/bin/sh

# Set the repository directory
REPO_DIR="/app/refid_cache"
SLEEP_DURATION="12h"

# Function to perform git pull with error handling
git_pull() {
    echo "Pulling latest changes from repository..."
    if git -C "$REPO_DIR" pull; then
        echo "Successfully pulled latest changes."
        return 0
    else
        echo "WARNING: Failed to pull latest changes. Will retry in $SLEEP_DURATION."
        return 1
    fi
}

# Initial pull
if [ -d "$REPO_DIR/.git" ]; then
    git_pull
else
    echo "WARNING: Not a git repository. Skipping initial pull."
fi

# Start the update loop
echo "Starting update loop with interval: $SLEEP_DURATION"
while true; do
    sleep $SLEEP_DURATION
    git_pull
done
