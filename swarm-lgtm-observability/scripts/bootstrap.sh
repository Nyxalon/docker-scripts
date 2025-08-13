#!/usr/bin/env bash
set -euo pipefail

# Load .env if present; fall back to sensible defaults
if [[ -f ".env" ]]; then
  set -a
  source .env
  set +a
else
  export TRAEFIK_PUBLIC="${TRAEFIK_PUBLIC:-traefik-public}"
  export OBS_NET="${OBS_NET:-observability_net}"
fi

echo "==> Checking Docker..."
docker info >/dev/null

echo "==> Ensuring Swarm is initialized..."
if ! docker info --format '{{.Swarm.LocalNodeState}}' | grep -q 'active'; then
  docker swarm init >/dev/null
  echo "   Swarm initialized."
else
  echo "   Swarm already active."
fi

echo "==> Ensuring external overlay network '${TRAEFIK_PUBLIC}' exists..."
if ! docker network ls --format '{{.Name}}' | grep -qx "${TRAEFIK_PUBLIC}"; then
  docker network create --driver overlay --attachable "${TRAEFIK_PUBLIC}" >/dev/null
  echo "   Created overlay network: ${TRAEFIK_PUBLIC}"
else
  echo "   Overlay network already exists: ${TRAEFIK_PUBLIC}"
fi

echo "==> Done."