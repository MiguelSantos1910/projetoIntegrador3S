//Falta importar os valores dos sensores
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "NOME_DA_REDE";
const char* pwd  = "SENHA_DA_REDE";

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, pwd);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConectado ao WiFi!");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    // 1. Inicia a conexão com o endpoint de POST
    http.begin("http://ip do pc aqui/api/esp/update-valores");

    // 2. Define o tipo de conteúdo como JSON
    http.addHeader("Content-Type", "application/json");

    // 3. Prepara os dados JSON que serão enviados
    String json = "{";
    json += "\"temperatura\":" + String(celsius, 2) + ",";
    json += "\"umidade\":" + String(data.humidity, 1) + ",";
    json += "\"luminosidade\":" + String(lux, 2);
    json += "}";

    // 4. Envia a requisição POST e recebe o código de resposta
    int httpResponseCode = http.POST(json);

    if (httpResponseCode > 0) {
      Serial.print("Código de resposta HTTP: ");
      Serial.println(httpResponseCode);
      
      // O servidor retorna o objeto "criado" como confirmação
      String payload = http.getString();
      Serial.println("Resposta do Servidor:");
      Serial.println(payload);
    } else {
      Serial.print("Erro no envio do POST: ");
      Serial.println(httpResponseCode);
    }

    // 5. Libera os recursos
    http.end();
  }

  delay(10000); 
}
