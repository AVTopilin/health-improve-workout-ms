-- Создаем базу данных для Keycloak
CREATE DATABASE keycloak;

-- Создаем расширение для UUID
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Создаем схему для workout приложения
CREATE SCHEMA IF NOT EXISTS workout_schema;
