FROM alpine/git:latest

# Set working directory
WORKDIR /app

# Install necessary tools
RUN apk add --no-cache bash coreutils tzdata

# Set the repository URL and target directory
ARG REPO_URL="https://github.com/harness/refid_cache.git"
ENV TARGET_DIR="refid_cache"

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Calculate the date 3 months ago
ARG SINCE_DATE
RUN if [ -z "$SINCE_DATE" ]; then \
      export SINCE_DATE=$(date -d "3 months ago" +%Y-%m-%d); \
    fi && \
    echo "Cloning repository with history since: $SINCE_DATE"

# Clone the repository with shallow history
RUN git clone --shallow-since=$SINCE_DATE $REPO_URL /app/$TARGET_DIR || \
    { echo "Shallow clone failed, falling back to minimal clone"; \
      git clone --depth 1 $REPO_URL /app/$TARGET_DIR; }

# Set the working directory to the cloned repository
WORKDIR /app/$TARGET_DIR

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Default command (can be overridden)
CMD ["sh"]