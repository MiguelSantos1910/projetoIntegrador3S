CREATE TABLE esp_dados (
    id SERIAL PRIMARY KEY,
    temperatura FLOAT,
    umidade FLOAT,
    luminosidade FLOAT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario_dados (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL
);
