# Start:

```sh
docker-compose up otusdb
```

# Connect to db:

```sh
docker-compose exec otusdb mysql -u root -p12345 shop
```

# Usage in applications:

```sh
mysql -u root -p12345 --port=3309 --protocol=tcp shop
```

# Stop:

```sh
docker-compose down -v --remove-orphans
```

# Benchmark:

```sh
docker-compose exec otusdb /bin/bash

apt update && apt install -y sysbench

sysbench --mysql-host=localhost --mysql-user=root --mysql-password=12345 \
  --db-driver=mysql --mysql-db=shop --test=oltp run
```