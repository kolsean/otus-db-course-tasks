# Start

```sh
docker-compose up -d otusdb
```

# Connect with psql

```sh
docker-compose exec otusdb psql -U postgres
```

# Connect with pgAdmin
[pgadmin_connection_manual.pdf](https://github.com/kolsean/otus-db-course-tasks/blob/master/task07/pgadmin_connection_manual.pdf)

# Stop
```sh
docker-compose down -v --remove-orphans
```
