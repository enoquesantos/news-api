CREATE TABLE IF NOT EXISTS `news` (
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `source_id` TEXT  NOT NULL,
    `source` TEXT  NOT NULL,
    `author` TEXT NOT NULL,
    `title` TEXT NOT NULL UNIQUE,
    `description` TEXT  NOT NULL,
    `url` TEXT  NOT NULL,
    `urlToImage` TEXT  NOT NULL,
    `publishedAt` NOT NULL
);

CREATE TABLE IF NOT EXISTS `sources` (
    `id` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    `source_id` TEXT  NOT NULL UNIQUE,
    `name` TEXT  NOT NULL,
    `description` TEXT  NOT NULL,
    `url` TEXT  NOT NULL,
    `category` TEXT  NOT NULL,
    `language` TEXT NOT NULL,
    `country` TEXT NOT NULL
);
