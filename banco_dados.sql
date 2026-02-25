CREATE TABLE esp_dados(
id INT AUTO_INCREMENT PRIMARY KEY,
temperatura FLOAT,
umidade FLOAT,
luminosidade FLOAT,
data_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usuario_dados(
id INT AUTO_INCREMENT PRIMARY KEY,
nome VARCHAR(30) NOT NULL,
email VARCHAR(50) NOT NULL UNIQUE,
senha VARCHAR(100) NOT NULL,
PRIMARY KEY (id)
);

DELIMITER$$
CREATE PROCEDURE atualizar_dados_esp(
    IN p_id INT
    IN p_temperatura FLOAT, 
    IN p_umidade FLOAT, 
    IN p_luminosidade INT
)
BEGIN
   UPDATE esp_dados
    SET
        temperatura = p_temperatura,
        umidade = p_umidade,
        luminosidade = p_luminosidade,
        data_registro = NOW()
    WHERE id = p_id;
END $$

DELIMITER ;
