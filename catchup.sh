#!/bin/bash
docker compose exec algorand-node goal node catchup $(curl -s https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/$1/latest.catchpoint)
