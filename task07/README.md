# Start

```sh
docker-compose up -d otusdb
```

# Connect

```sh
docker-compose exec otusdb psql -U postgres
```

# Stop
```sh
docker-compose down -v --remove-orphans
```
