USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

postgres:
	docker run --name core-postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -v $(shell pwd)/.postgres-data:/var/lib/postgresql/data -d postgres:16-alpine

createdb:
	docker exec -it core-postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it core-postgres dropdb simple_bank

migrateup:
	docker run --rm -v $(shell pwd)/db/migration:/migrations --network host migrate/migrate \
		-path=/migrations/ \
		-database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" \
		up

migratedown:
	docker run --rm -v $(shell pwd)/db/migration:/migrations --network host migrate/migrate \
		-path=/migrations/ \
		-database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" \
		down

sqlc:
	docker run --rm -v $(shell pwd):/src -w /src -u $(USER_ID):$(GROUP_ID) sqlc/sqlc generate

test:
	go test -v -cover ./internal/data/...

.PHONY: postgres createdb dropdb migrateup migratedown sqlc test