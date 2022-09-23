#!/bin/bash
docker compose --project-directory "$(dirname "$0")" exec algorand-node goal "$@"
