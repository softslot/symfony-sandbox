init-project: docker-down-clear docker-pull docker-build docker-up composer-install migrate

docker-down-clear:
	docker compose down -v --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build

docker-up:
	docker compose up -d

composer-install:
	docker compose exec app composer install

migrate: wait-db migrate-app

wait-db:
	until docker compose exec -T database pg_isready --timeout=0 --dbname=app; do sleep 1 ; done

migrate-app:
	docker compose exec app ./bin/console doctrine:migrations:migrate --no-interaction

check: lint analyze tests

lint:
	docker compose exec app ./vendor/bin/phpcbf && \
	docker compose exec app ./bin/console lint:twig templates

analyze:
	docker compose exec app ./vendor/bin/phpstan analyse src tests

tests:
	docker compose exec app ./bin/phpunit