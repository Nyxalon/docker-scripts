#!/usr/bin/env bash
set -euo pipefail

# check and load the .env file
echo "debug: check and load environment variables."
if [[ -f ".env" ]]; then
  set -a
  source .env
  set +a
  echo "info: environment variables successfully exported."
else
  echo "error: environment variables not found."
  exit 1
fi

# checking docker and swarm
echo ""
echo "debug: checking docker."
docker info >/dev/null
echo "info: docker is active."

echo ""
echo "debug: ensuring swarm is initialized..."
if [[ $(docker info --format '{{.Swarm.LocalNodeState}}') == 'inactive' ]]; then
  # change the --advertise-addr to the actual one.
  if docker swarm init --advertise-addr eth0 &>/dev/null; then
    echo "info: swarm initialized."
  else
    echo "error: failed to initialize swarm."
    exit 1
  fi
else
  echo "info: swarm already active."
fi

# checking docker and swarm networks
echo ""
echo "debug: ensuring external overlay network '${TRAEFIK_PUBLIC}' exists."
if ! docker network ls --format '{{.Name}}' | grep -qx "${TRAEFIK_PUBLIC}"; then
  docker network create --driver overlay --attachable "${TRAEFIK_PUBLIC}" >/dev/null
  echo "info: created overlay network - ${TRAEFIK_PUBLIC}"
else
  echo "info: overlay network already exists: ${TRAEFIK_PUBLIC}"
fi

echo ""
echo "info: docker and swarm configurations success."
