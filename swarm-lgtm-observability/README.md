# Docker Swarm – LGTM Observability

LGTM stack (Loki, Grafana, Tempo, Prometheus) on Docker Swarm.

## Quickstart
```bash
cp .env.example .env
bash scripts/bootstrap.sh
docker network ls --filter driver=overlay

### Deploy Stacks
docker stack deploy -c stacks/reverse-proxy/stack.yml reverse-proxy

##### To Check:
docker service ls
docker service ps reverse-proxy_traefik