# Start

```sh
docker-compose up -d otusdb
```

# Connect with psql

```sh
docker-compose exec otusdb psql "postgresql://otusdb_admin:12345@otusdb/otusdb"

\dt
                   List of relations
  Schema  |        Name         | Type  |    Owner
----------+---------------------+-------+--------------
 deal     | currency            | table | otusdb_admin
 deal     | order               | table | otusdb_admin
 deal     | product_buy         | table | otusdb_admin
 deal     | product_sell        | table | otusdb_admin
 location | address             | table | otusdb_admin
 location | city                | table | otusdb_admin
 location | country             | table | otusdb_admin
 location | region              | table | otusdb_admin
 location | street              | table | otusdb_admin
 shop     | category            | table | otusdb_admin
 shop     | customer            | table | otusdb_admin
 shop     | dealer              | table | otusdb_admin
 shop     | dealer_manufacturer | table | otusdb_admin
 shop     | manufacturer        | table | otusdb_admin
 shop     | product             | table | otusdb_admin
 shop     | product_param       | table | otusdb_admin
(16 rows)

\q
```

# Stop

```sh
docker-compose down -v --remove-orphans
```
