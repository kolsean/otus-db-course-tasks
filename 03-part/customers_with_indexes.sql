CREATE TYPE "customer_gender" AS ENUM (
  'male',
  'female'
);

CREATE TYPE "customer_marital_status" AS ENUM (
  'single',
  'married',
  'divorced',
  'widowed'
);

CREATE TYPE "payment_type" AS ENUM (
  'cash',
  'online',
  'card'
);

CREATE TYPE "trade_status" AS ENUM (
  'income',
  'refund'
);

CREATE TABLE "country" (
  "id_country" SERIAL PRIMARY KEY,
  "name" char
);

CREATE TABLE "region" (
  "id_region" SERIAL PRIMARY KEY,
  "id_country" int,
  "name" varchar
);

CREATE TABLE "city" (
  "id_city" SERIAL PRIMARY KEY,
  "id_region" int,
  "name" varchar
);

CREATE TABLE "street" (
  "id_street" SERIAL PRIMARY KEY,
  "id_city" int,
  "name" varchar
);

CREATE TABLE "address" (
  "id_address" SERIAL PRIMARY KEY,
  "id_street" int,
  "building_num" varchar,
  "apartment_num" int,
  "postal_code" varchar
);

CREATE TABLE "customer" (
  "id_customer" SERIAL PRIMARY KEY,
  "created_at" date,
  "updated_at" date,
  "first_name" varchar,
  "last_name" varchar,
  "birth_date" date,
  "phone_number" varchar,
  "email" varchar,
  "id_title" int,
  "gender" customer_gender,
  "marital_status" customer_marital_status
);

CREATE TABLE "title" (
  "id_title" SERIAL PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "product" (
  "id_product" SERIAL PRIMARY KEY,
  "name" varchar,
  "created_at" date,
  "updated_at" date,
  "deleted_at" date,
  "id_category" int,
  "id_manufacturer" int
);

CREATE TABLE "product_param" (
  "id_product_param" SERIAL PRIMARY KEY,
  "name" varchar,
  "created_at" date,
  "updated_at" date,
  "deleted_at" date,
  "int_value" int,
  "float_value" float,
  "text_value" text,
  "varchar_value" varchar,
  "id_product" int
);

CREATE TABLE "category" (
  "id_category" SERIAL PRIMARY KEY,
  "name" int,
  "parent_id" int
);

CREATE TABLE "manufacturer" (
  "id_manufacturer" SERIAL PRIMARY KEY,
  "name" varchar,
  "phone" varchar,
  "id_address" int,
  "comment" varchar
);

CREATE TABLE "dealer" (
  "id_dealer" SERIAL PRIMARY KEY,
  "name" varchar,
  "phone" varchar,
  "id_address" int,
  "comment" varchar
);

CREATE TABLE "dealer_manufacturer" (
  "id_dealer" int,
  "id_manufacturer" int,
  "comment" varchar,
  PRIMARY KEY ("id_dealer", "id_manufacturer")
);

CREATE TABLE "order" (
  "id_order" SERIAL PRIMARY KEY,
  "created_at" date,
  "id_language" int,
  "id_customer" int,
  "id_address" int,
  "type" payment_type
);

CREATE TABLE "language" (
  "id_language" SERIAL PRIMARY KEY,
  "name" char
);

CREATE TABLE "product_buy" (
  "id_product_buy" SERIAL PRIMARY KEY,
  "created_at" date,
  "price" int,
  "id_currency" int,
  "id_dealer" int,
  "id_product" int,
  "quantity" int,
  "status" trade_status
);

CREATE TABLE "product_sell" (
  "id_product_sale" SERIAL PRIMARY KEY,
  "created_at" date,
  "price" int,
  "id_currency" int,
  "id_order" int,
  "id_product" int,
  "quantity" int,
  "status" trade_status
);

CREATE TABLE "currency" (
  "id_currency" SERIAL PRIMARY KEY,
  "created_at" date,
  "name" varchar,
  "code" varchar,
  "rate" decimal
);

ALTER TABLE "region" ADD FOREIGN KEY ("id_country") REFERENCES "country" ("id_country");

ALTER TABLE "city" ADD FOREIGN KEY ("id_region") REFERENCES "region" ("id_region");

ALTER TABLE "street" ADD FOREIGN KEY ("id_city") REFERENCES "city" ("id_city");

ALTER TABLE "address" ADD FOREIGN KEY ("id_street") REFERENCES "street" ("id_street");

ALTER TABLE "manufacturer" ADD FOREIGN KEY ("id_address") REFERENCES "address" ("id_address");

ALTER TABLE "dealer" ADD FOREIGN KEY ("id_address") REFERENCES "address" ("id_address");

ALTER TABLE "customer" ADD FOREIGN KEY ("id_title") REFERENCES "title" ("id_title");

ALTER TABLE "product" ADD FOREIGN KEY ("id_manufacturer") REFERENCES "manufacturer" ("id_manufacturer");

ALTER TABLE "dealer_manufacturer" ADD FOREIGN KEY ("id_manufacturer") REFERENCES "manufacturer" ("id_manufacturer");

ALTER TABLE "dealer_manufacturer" ADD FOREIGN KEY ("id_dealer") REFERENCES "dealer" ("id_dealer");

ALTER TABLE "product" ADD FOREIGN KEY ("id_category") REFERENCES "category" ("id_category");

ALTER TABLE "product_param" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id_product");

ALTER TABLE "order" ADD FOREIGN KEY ("id_customer") REFERENCES "customer" ("id_customer");

ALTER TABLE "order" ADD FOREIGN KEY ("id_address") REFERENCES "address" ("id_address");

ALTER TABLE "order" ADD FOREIGN KEY ("id_language") REFERENCES "language" ("id_language");

ALTER TABLE "product_buy" ADD FOREIGN KEY ("id_dealer") REFERENCES "dealer" ("id_dealer");

ALTER TABLE "product_buy" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id_product");

ALTER TABLE "product_buy" ADD FOREIGN KEY ("id_currency") REFERENCES "currency" ("id_currency");

ALTER TABLE "product_sell" ADD FOREIGN KEY ("id_order") REFERENCES "order" ("id_order");

ALTER TABLE "product_sell" ADD FOREIGN KEY ("id_product") REFERENCES "product" ("id_product");

ALTER TABLE "product_sell" ADD FOREIGN KEY ("id_currency") REFERENCES "currency" ("id_currency");

CREATE INDEX ON "customer" ("first_name", "last_name");

CREATE INDEX ON "customer" ("phone_number");

CREATE INDEX ON "customer" ("email");

CREATE INDEX ON "product" ("name");

CREATE UNIQUE INDEX ON "manufacturer" ("name");

CREATE UNIQUE INDEX ON "dealer" ("name");

CREATE INDEX ON "order" ("created_at");

CREATE INDEX ON "product_buy" ("created_at");

CREATE INDEX ON "product_sell" ("created_at");

CREATE INDEX ON "currency" ("name", "created_at");

COMMENT ON COLUMN "country"."id_country" IS 'It`s an identifier of the country';

COMMENT ON COLUMN "country"."name" IS 'Represents the name of the country';

COMMENT ON COLUMN "region"."id_region" IS 'It`s an identifier of the region';

COMMENT ON COLUMN "region"."id_country" IS 'It contains a reference to the country`s identifier where the region is located';

COMMENT ON COLUMN "region"."name" IS 'Represents the name of the specific region';

COMMENT ON COLUMN "city"."id_city" IS 'It`s an identifier of the city';

COMMENT ON COLUMN "city"."id_region" IS 'It contains a reference to the region`s identifier where the city is located';

COMMENT ON COLUMN "city"."name" IS 'Represents the name of the city';

COMMENT ON COLUMN "street"."id_street" IS 'It`s an identifier of the street';

COMMENT ON COLUMN "street"."id_city" IS 'It contains a reference to the city identifier where the street is located';

COMMENT ON COLUMN "street"."name" IS 'Represents the name of the street';

COMMENT ON COLUMN "address"."id_address" IS 'It`s an identifier of the address';

COMMENT ON COLUMN "address"."id_street" IS 'It contains a reference to the street`s identifier which is a part of the particular address';

COMMENT ON COLUMN "address"."building_num" IS 'It`s a building number on the street. It may contain literal characters to help identify a specific address';

COMMENT ON COLUMN "address"."apartment_num" IS 'It`s the apartment number';

COMMENT ON COLUMN "address"."postal_code" IS 'Represents the postal code of the specific address';

COMMENT ON COLUMN "customer"."id_customer" IS 'It`s an identifier of the customer';

COMMENT ON COLUMN "customer"."created_at" IS 'Represents time when the customer information has been created';

COMMENT ON COLUMN "customer"."updated_at" IS 'Represents time when the customer information has been updated';

COMMENT ON COLUMN "customer"."first_name" IS 'Represents customer first name';

COMMENT ON COLUMN "customer"."last_name" IS 'Represents customer last name';

COMMENT ON COLUMN "customer"."birth_date" IS 'Represents customer birth date';

COMMENT ON COLUMN "customer"."phone_number" IS 'Represents customer phone number';

COMMENT ON COLUMN "customer"."email" IS 'Represents customer email address';

COMMENT ON COLUMN "customer"."id_title" IS 'It contains a reference to the customer courtesy title';

COMMENT ON COLUMN "customer"."gender" IS 'It`s reference to the gender of customer';

COMMENT ON COLUMN "customer"."marital_status" IS 'It contains a reference to the customer marital status';

COMMENT ON COLUMN "title"."id_title" IS 'It`s an identifier of the title';

COMMENT ON COLUMN "title"."name" IS 'Represents a person title name';

COMMENT ON COLUMN "product"."id_product" IS 'It`s an identifier of the product';

COMMENT ON COLUMN "product"."name" IS 'It`s a product name';

COMMENT ON COLUMN "product"."created_at" IS 'Represents time when the product has been created';

COMMENT ON COLUMN "product"."updated_at" IS 'Represents time when the product has been updated';

COMMENT ON COLUMN "product"."deleted_at" IS 'Represents time when the product has been deleted';

COMMENT ON COLUMN "product"."id_category" IS 'Represents a reference to the category identifier this product belongs to';

COMMENT ON COLUMN "product"."id_manufacturer" IS 'It`s a reference to the manufacturer who produces this product';

COMMENT ON COLUMN "product_param"."id_product_param" IS 'It`s an identifier of the product parameter';

COMMENT ON COLUMN "product_param"."name" IS 'Represents name of product parameter';

COMMENT ON COLUMN "product_param"."created_at" IS 'Represents time when the parameter has been created';

COMMENT ON COLUMN "product_param"."updated_at" IS 'Represents time when the parameter has been updated';

COMMENT ON COLUMN "product_param"."deleted_at" IS 'Represents time when the parameter has been deleted';

COMMENT ON COLUMN "product_param"."int_value" IS 'It contains parameter number value';

COMMENT ON COLUMN "product_param"."float_value" IS 'It contains parameter floating value';

COMMENT ON COLUMN "product_param"."text_value" IS 'It contains parameter text value';

COMMENT ON COLUMN "product_param"."varchar_value" IS 'It contains parameter short-text value';

COMMENT ON COLUMN "product_param"."id_product" IS 'It contains a reference to the product identifier';

COMMENT ON COLUMN "category"."id_category" IS 'It`s an identifier of the category';

COMMENT ON COLUMN "category"."name" IS 'Represents name of the category';

COMMENT ON COLUMN "category"."parent_id" IS 'It contains an identifier of the parent category';

COMMENT ON COLUMN "manufacturer"."id_manufacturer" IS 'It`s an identifier of the manufacturer';

COMMENT ON COLUMN "manufacturer"."name" IS 'Represents manufacturer name';

COMMENT ON COLUMN "manufacturer"."phone" IS 'It contains manufacturer phone number';

COMMENT ON COLUMN "manufacturer"."id_address" IS 'It`s a reference to the address identifier where the manufacturer is located';

COMMENT ON COLUMN "manufacturer"."comment" IS 'This field might contain an additional information about manufacturer';

COMMENT ON COLUMN "dealer"."id_dealer" IS 'It`s an identifier of the dealer';

COMMENT ON COLUMN "dealer"."name" IS 'It`s dealer name';

COMMENT ON COLUMN "dealer"."phone" IS 'It contains dealer phone number';

COMMENT ON COLUMN "dealer"."id_address" IS 'It`s a reference to the address identifier where the dealer is located';

COMMENT ON COLUMN "dealer"."comment" IS 'This field might contain an additional information about dealer';

COMMENT ON COLUMN "dealer_manufacturer"."id_dealer" IS 'It`s an identifier of the dealer';

COMMENT ON COLUMN "dealer_manufacturer"."id_manufacturer" IS 'It`s an identifier of the manufacturer';

COMMENT ON COLUMN "dealer_manufacturer"."comment" IS 'This field might contain an additional information about dealer_manufacturer relationship';

COMMENT ON COLUMN "order"."id_order" IS 'It`s an identifier of the customers order';

COMMENT ON COLUMN "order"."created_at" IS 'Represents time when the customer created the order';

COMMENT ON COLUMN "order"."id_language" IS 'It`s a reference to the language that the customer chose when ordering';

COMMENT ON COLUMN "order"."id_customer" IS 'It`s a reference to the customer who made the order';

COMMENT ON COLUMN "order"."id_address" IS 'It`s a reference to the delivery address';

COMMENT ON COLUMN "order"."type" IS 'Represents type of payment for the specific order';

COMMENT ON COLUMN "language"."id_language" IS 'It`s an identifier of the language';

COMMENT ON COLUMN "language"."name" IS 'It contains a name of the language code';

COMMENT ON COLUMN "product_buy"."id_product_buy" IS 'It`s an identifier of the trade with dealer';

COMMENT ON COLUMN "product_buy"."created_at" IS 'Represents time when a product has been purchased from dealer';

COMMENT ON COLUMN "product_buy"."price" IS 'Represents the price at which the product was bought';

COMMENT ON COLUMN "product_buy"."id_currency" IS 'It contains a reference to the currency identifier in which the price is stored';

COMMENT ON COLUMN "product_buy"."id_dealer" IS 'It contains a reference to the dealer who sold the product';

COMMENT ON COLUMN "product_buy"."id_product" IS 'It contains a reference to the product that was purchased';

COMMENT ON COLUMN "product_buy"."quantity" IS 'Represents count of the product that has been bought';

COMMENT ON COLUMN "product_buy"."status" IS 'Represents a status of the transaction';

COMMENT ON COLUMN "product_sell"."id_product_sale" IS 'It`s an identifier of the trade with customer';

COMMENT ON COLUMN "product_sell"."created_at" IS 'Represents time when a product has been sold to the customer';

COMMENT ON COLUMN "product_sell"."price" IS 'Represents the price at which the product was sold';

COMMENT ON COLUMN "product_sell"."id_currency" IS 'It contains a reference to the currency identifier in which the price is stored';

COMMENT ON COLUMN "product_sell"."id_order" IS 'It contains a reference to the order within which the product was sold';

COMMENT ON COLUMN "product_sell"."id_product" IS 'It contains a reference to the product that was sold';

COMMENT ON COLUMN "product_sell"."quantity" IS 'Represents a count of sold product';

COMMENT ON COLUMN "product_sell"."status" IS 'Represents status of the transaction';

COMMENT ON COLUMN "currency"."id_currency" IS 'It`s an identifier of the specific currency';

COMMENT ON COLUMN "currency"."created_at" IS 'Represents time when the currency rate was added';

COMMENT ON COLUMN "currency"."name" IS 'Represents currency name';

COMMENT ON COLUMN "currency"."code" IS 'Represents currency short code';

COMMENT ON COLUMN "currency"."rate" IS 'Represents currency bank rate';
