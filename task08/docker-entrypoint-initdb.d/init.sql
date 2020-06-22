CREATE ROLE otusdb_admin WITH SUPERUSER LOGIN PASSWORD '12345';

ALTER ROLE otusdb_admin SET search_path = location,shop,deal,public;

CREATE TABLESPACE otusdb_basic_ts OWNER otusdb_admin LOCATION '/var/lib/postgresql';
CREATE TABLESPACE otusdb_fast_ts OWNER otusdb_admin LOCATION '/var/lib/postgresql/data';

CREATE DATABASE otusdb WITH OWNER otusdb_admin TABLESPACE otusdb_basic_ts;

\connect otusdb otusdb_admin;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS location AUTHORIZATION otusdb_admin;
CREATE SCHEMA IF NOT EXISTS shop AUTHORIZATION otusdb_admin;
CREATE SCHEMA IF NOT EXISTS deal AUTHORIZATION otusdb_admin;

CREATE TYPE "customer_title" AS ENUM ('Mr','Mrs','Ms','Miss');
CREATE TYPE "customer_gender" AS ENUM ('male', 'female');
CREATE TYPE "customer_marital_status" AS ENUM ('single', 'married', 'divorced', 'widowed');
CREATE TYPE "payment_type" AS ENUM ('cash', 'online', 'card');
CREATE TYPE "trade_status" AS ENUM ('income', 'refund');
CREATE TYPE "order_language" AS ENUM ('RU', 'EN');

CREATE TABLE location.country (
    "id_country" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "name" VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE location.region (
    "id_region" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "id_country" uuid NOT NULL,
    "name" VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE location.city (
    "id_city" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "id_region" uuid NOT NULL,
    "name" VARCHAR(100) NOT NULL
);

CREATE TABLE location.street (
    "id_street" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "id_city" uuid NOT NULL,
    "name" VARCHAR(100) NOT NULL
);
CREATE TABLE location.address (
    "id_address" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "id_street" uuid NOT NULL,
    "building_num" VARCHAR(100),
    "appartment_num" VARCHAR(100),
    "postal_code" VARCHAR(100) NOT NULL

);

CREATE TABLE shop.dealer (
    "id_dealer" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "name" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(100),
    "id_address" uuid NOT NULL,
    "comment" VARCHAR(255)
);

CREATE TABLE shop.manufacturer (
    "id_manufacturer" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "name" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(100),
    "id_address" uuid NOT NULL,
    "comment" VARCHAR(255)
);
CREATE TABLE shop.dealer_manufacturer (
    "id_dealer" uuid NOT NULL,
    "id_manufacturer" uuid NOT NULL,
    "comment" VARCHAR(255)
);

CREATE TABLE shop.category (
    "id_category" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "name" VARCHAR(255) NOT NULL,
    "parent_id" uuid
);

CREATE TABLE shop.product (
    "id_product" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP DEFAULT (now()),
    "updated_at" TIMESTAMP,
    "deleted_at" TIMESTAMP,
    "id_category" uuid NOT NULL,
    "id_manufacturer" uuid NOT NULL
);

CREATE TABLE shop.product_param (
    "id_product_param" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "name" VARCHAR(255) NOT NULL,
    "created_at" TIMESTAMP DEFAULT (now()),
    "updated_at" TIMESTAMP,
    "deleted_at" TIMESTAMP,
    "int_value" INTEGER,
    "float_value" DOUBLE PRECISION,
    "text_value" VARCHAR(255),
    "id_product" uuid NOT NULL
);

CREATE TABLE shop.customer (
    "id_customer" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "created_at" TIMESTAMP DEFAULT (now()),
    "updated_at" TIMESTAMP,
    "first_name" VARCHAR(255) NOT NULL,
    "last_name" VARCHAR(255) NOT NULL,
    "birth_date" date,
    "phone_number" VARCHAR(100),
    "email" VARCHAR(255),
    "title" "customer_title",
    "gender" "customer_gender",
    "marital_status" "customer_marital_status"
);

CREATE TABLE deal.currency (
    "id_currency" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "created_at" TIMESTAMP DEFAULT (now()),
    "code" VARCHAR(100) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "rate" NUMERIC(2) NOT NULL
) TABLESPACE otusdb_fast_ts;

CREATE TABLE deal.product_buy (
    "id_product_buy" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "created_at" TIMESTAMP DEFAULT (now()),
    "price" NUMERIC(2) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "status" "trade_status",
    "id_currency" uuid NOT NULL,
    "id_dealer" uuid NOT NULL,
    "id_product" uuid NOT NULL
) TABLESPACE otusdb_fast_ts;

CREATE TABLE deal.product_sell (
    "id_product_sell" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "created_at" TIMESTAMP DEFAULT (now()),
    "price" NUMERIC(2) NOT NULL,
    "quantity" INTEGER NOT NULL,
    "status" "trade_status",
    "id_currency" uuid NOT NULL,
    "id_product" uuid NOT NULL,
    "id_order" uuid NOT NULL
) TABLESPACE otusdb_fast_ts;

CREATE TABLE deal.order(
    "id_order" uuid PRIMARY KEY DEFAULT (uuid_generate_v4()),
    "created_at" TIMESTAMP DEFAULT (now()),
    "language" "order_language",
    "type" "payment_type",
    "id_customer" uuid NOT NULL,
    "id_address" uuid NOT NULL
) TABLESPACE otusdb_fast_ts;

ALTER TABLE "region" ADD FOREIGN KEY ("id_country") REFERENCES "country" ("id_country");

ALTER TABLE "city" ADD FOREIGN KEY ("id_region") REFERENCES "region" ("id_region");

ALTER TABLE "street" ADD FOREIGN KEY ("id_city") REFERENCES "city" ("id_city");

ALTER TABLE "address" ADD FOREIGN KEY ("id_street") REFERENCES "street" ("id_street");

ALTER TABLE "manufacturer" ADD FOREIGN KEY ("id_address") REFERENCES "address" ("id_address");

ALTER TABLE "dealer" ADD FOREIGN KEY ("id_address") REFERENCES "address" ("id_address");

ALTER TABLE "product" ADD FOREIGN KEY ("id_manufacturer") REFERENCES "manufacturer" ("id_manufacturer");

ALTER TABLE "dealer_manufacturer" ADD FOREIGN KEY ("id_manufacturer") REFERENCES "manufacturer" ("id_manufacturer");

ALTER TABLE "dealer_manufacturer" ADD FOREIGN KEY ("id_dealer") REFERENCES "dealer" ("id_dealer");

ALTER TABLE "product" ADD FOREIGN KEY ("id_category") REFERENCES "category" ("id_category");

ALTER TABLE "product_param" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id_product");

ALTER TABLE "order" ADD FOREIGN KEY ("id_customer") REFERENCES "customer" ("id_customer");

ALTER TABLE "order" ADD FOREIGN KEY ("id_address") REFERENCES "address" ("id_address");

ALTER TABLE "product_buy" ADD FOREIGN KEY ("id_dealer") REFERENCES "dealer" ("id_dealer");

ALTER TABLE "product_buy" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id_product");

ALTER TABLE "product_buy" ADD FOREIGN KEY ("id_currency") REFERENCES "currency" ("id_currency");

ALTER TABLE "product_sell" ADD FOREIGN KEY ("id_order") REFERENCES "order" ("id_order");

ALTER TABLE "product_sell" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id_product");

ALTER TABLE "product_sell" ADD FOREIGN KEY ("id_currency") REFERENCES "currency" ("id_currency");

CREATE INDEX "idx_customer_first_name_last_name" ON "customer" ("first_name", "last_name");

CREATE INDEX "idx_customer_phone_number" ON "customer" ("phone_number");

CREATE INDEX "idx_customer_email" ON "customer" ("email");

CREATE INDEX "idx_product_name" ON "product" ("name");

CREATE UNIQUE INDEX "idx_manufacturer_name" ON "manufacturer" ("name");

CREATE UNIQUE INDEX "idx_dealer_name" ON "dealer" ("name");

CREATE INDEX "idx_order_created_at" ON "order" ("created_at");

CREATE INDEX "idx_product_buy_created_at" ON "product_buy" ("created_at");

CREATE INDEX "idx_product_sell_created_at" ON "product_sell" ("created_at");

CREATE INDEX "idx_currency_code_created_at" ON "currency" ("code", "created_at");
