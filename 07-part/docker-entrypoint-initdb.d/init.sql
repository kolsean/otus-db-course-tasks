CREATE DATABASE shop;
USE shop;

CREATE TABLE `country` (
    `id_country` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE `region` (
  `id_region` INT PRIMARY KEY AUTO_INCREMENT,
  `id_country` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `city` (
  `id_city` INT PRIMARY KEY AUTO_INCREMENT,
  `id_region` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `street` (
  `id_street` INT PRIMARY KEY AUTO_INCREMENT,
  `id_city` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `address` (
  `id_address` INT PRIMARY KEY AUTO_INCREMENT,
  `id_street` INT NOT NULL,
  `building_num` VARCHAR(255),
  `apartment_num` INT,
  `postal_code` VARCHAR(255) NOT NULL
);

CREATE TABLE `customer` (
  `id_customer` INT PRIMARY KEY AUTO_INCREMENT,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp,
  `first_name` VARCHAR(255) NOT NULL,
  `last_name` VARCHAR(255) NOT NULL,
  `birth_date` timestamp NOT NULL CHECK (birth_date > '1900-01-01'),
  `phone_number` VARCHAR(255),
  `email` VARCHAR(255) UNIQUE NOT NULL,
  `id_title` INT NOT NULL,
  `gender` ENUM ('male', 'female') NOT NULL,
  `marital_status` ENUM ('single', 'married', 'divorced', 'widowed') NOT NULL
);

CREATE TABLE `title` (
  `id_title` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `product` (
  `id_product` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp,
  `deleted_at` timestamp,
  `id_category` INT NOT NULL,
  `id_manufacturer` INT NOT NULL
);

CREATE TABLE `product_param` (
  `id_product_param` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp,
  `deleted_at` timestamp,
  `INT_value` INT,
  `FLOAT_value` float,
  `VARCHAR_value` VARCHAR(255),
  `id_product` INT NOT NULL
);

CREATE TABLE `category` (
  `id_category` INT PRIMARY KEY AUTO_INCREMENT,
  `name` INT NOT NULL,
  `parent_id` INT
);

CREATE TABLE `manufacturer` (
  `id_manufacturer` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255),
  `id_address` INT NOT NULL,
  `comment` VARCHAR(255)
);

CREATE TABLE `dealer` (
  `id_dealer` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255),
  `id_address` INT NOT NULL,
  `comment` VARCHAR(255)
);

CREATE TABLE `dealer_manufacturer` (
  `id_dealer` INT,
  `id_manufacturer` INT,
  `comment` VARCHAR(255),
  PRIMARY KEY (`id_dealer`, `id_manufacturer`)
);

CREATE TABLE `order` (
  `id_order` INT PRIMARY KEY AUTO_INCREMENT,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `id_language` INT NOT NULL,
  `id_customer` INT NOT NULL,
  `id_address` INT NOT NULL,
  `type` ENUM ('cash', 'online', 'card') NOT NULL
);

CREATE TABLE `language` (
  `id_language` INT PRIMARY KEY AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL
);

CREATE TABLE `product_buy` (
  `id_product_buy` INT PRIMARY KEY AUTO_INCREMENT,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `price` INT NOT NULL CHECK(price > 0),
  `id_currency` INT NOT NULL,
  `id_dealer` INT NOT NULL,
  `id_product` INT NOT NULL,
  `quantity` INT NOT NULL,
  `status` ENUM ('income', 'refund') NOT NULL
);

CREATE TABLE `product_sell` (
  `id_product_sale` INT PRIMARY KEY AUTO_INCREMENT,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `price` INT NOT NULL CHECK(price > 0),
  `id_currency` INT NOT NULL,
  `id_order` INT NOT NULL,
  `id_product` INT NOT NULL,
  `quantity` INT NOT NULL,
  `status` ENUM ('income', 'refund') NOT NULL
);

CREATE TABLE `currency` (
  `id_currency` INT PRIMARY KEY AUTO_INCREMENT,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `name` VARCHAR(255) NOT NULL,
  `code` VARCHAR(255) NOT NULL,
  `rate` decimal NOT NULL
);

ALTER TABLE `region` ADD FOREIGN KEY (`id_country`) REFERENCES `country` (`id_country`);

ALTER TABLE `city` ADD FOREIGN KEY (`id_region`) REFERENCES `region` (`id_region`);

ALTER TABLE `street` ADD FOREIGN KEY (`id_city`) REFERENCES `city` (`id_city`);

ALTER TABLE `address` ADD FOREIGN KEY (`id_street`) REFERENCES `street` (`id_street`);

ALTER TABLE `manufacturer` ADD FOREIGN KEY (`id_address`) REFERENCES `address` (`id_address`);

ALTER TABLE `dealer` ADD FOREIGN KEY (`id_address`) REFERENCES `address` (`id_address`);

ALTER TABLE `customer` ADD FOREIGN KEY (`id_title`) REFERENCES `title` (`id_title`);

ALTER TABLE `product` ADD FOREIGN KEY (`id_manufacturer`) REFERENCES `manufacturer` (`id_manufacturer`);

ALTER TABLE `dealer_manufacturer` ADD FOREIGN KEY (`id_manufacturer`) REFERENCES `manufacturer` (`id_manufacturer`);

ALTER TABLE `dealer_manufacturer` ADD FOREIGN KEY (`id_dealer`) REFERENCES `dealer` (`id_dealer`);

ALTER TABLE `product` ADD FOREIGN KEY (`id_category`) REFERENCES `category` (`id_category`);

ALTER TABLE `product_param` ADD FOREIGN KEY (`id_product`) REFERENCES `product` (`id_product`);

ALTER TABLE `order` ADD FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`);

ALTER TABLE `order` ADD FOREIGN KEY (`id_address`) REFERENCES `address` (`id_address`);

ALTER TABLE `order` ADD FOREIGN KEY (`id_language`) REFERENCES `language` (`id_language`);

ALTER TABLE `product_buy` ADD FOREIGN KEY (`id_dealer`) REFERENCES `dealer` (`id_dealer`);

ALTER TABLE `product_buy` ADD FOREIGN KEY (`id_product`) REFERENCES `product` (`id_product`);

ALTER TABLE `product_buy` ADD FOREIGN KEY (`id_currency`) REFERENCES `currency` (`id_currency`);

ALTER TABLE `product_sell` ADD FOREIGN KEY (`id_order`) REFERENCES `order` (`id_order`);

ALTER TABLE `product_sell` ADD FOREIGN KEY (`id_product`) REFERENCES `product` (`id_product`);

ALTER TABLE `product_sell` ADD FOREIGN KEY (`id_currency`) REFERENCES `currency` (`id_currency`);

CREATE INDEX `customer_index_0` ON `customer` (`first_name`, `last_name`);

CREATE INDEX `customer_index_1` ON `customer` (`phone_number`);

CREATE INDEX `customer_index_2` ON `customer` (`email`);

CREATE INDEX `product_index_3` ON `product` (`name`);

CREATE UNIQUE INDEX `manufacturer_index_4` ON `manufacturer` (`name`);

CREATE UNIQUE INDEX `dealer_index_5` ON `dealer` (`name`);

CREATE INDEX `order_index_6` ON `order` (`created_at`);

CREATE INDEX `product_buy_index_7` ON `product_buy` (`created_at`);

CREATE INDEX `product_sell_index_8` ON `product_sell` (`created_at`);

CREATE INDEX `currency_index_9` ON `currency` (`name`, `created_at`);
