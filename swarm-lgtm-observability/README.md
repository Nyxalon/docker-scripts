# Docker Swarm – LGTM Observability

LGTM stack (Loki, Grafana, Tempo, Prometheus) on Docker Swarm.

## Quickstart
```bash
cp .env.example .env
bash scripts/bootstrap.sh
docker network ls --filter driver=overlay