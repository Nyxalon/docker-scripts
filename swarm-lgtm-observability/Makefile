init:
	bash scripts/swarm-init.sh

labels:
	bash scripts/swarm-label.sh

deploy:
	docker stack deploy -c stacks/monitoring.stack.yml lgtm

down:
	docker stack rm lgtm

validate:
	bash scripts/validate.sh