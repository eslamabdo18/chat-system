#!/bin/bash
set -e

cd /go/src/github.com/eslamabdo18/go-chat-apis
# Remove a potentially pre-existing server.pid for Rails.


# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"