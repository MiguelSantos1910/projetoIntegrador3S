#include <DHTesp.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <math.h>

DHTesp dhtSensor;

const char* ssid = "NOME_DA_REDE";
const char* pwd  = "SENHA_DA_REDE";

const int DHT_PIN = 16;

// IP do seu computador
String serverURL = "http://192.168.0.5:3000/api/esp/upload-dados";


// -------- FUNÇÕES DE LEITURA --------

float lerTemperaturaNTC() {
  const float BETA = 3950;

  int analogValue = analogRead(15);

  float celsius =
    1 / (log(1 / (1023.0 / analogValue - 1)) / BETA
    + 1.0 / 298.15) - 273.15;

  return celsius;
}

float lerLuminosidade() {
  const float GAMMA = 0.7;
  const float RL10 = 50;

  int analogValue = analogRead(2);

  float voltage = analogValue / 1024.0 * 5;

  float resistance =
    2000 * voltage / (1 - voltage / 5);

  float lux =
    pow(RL10 * 1e3 * pow(10, GAMMA) /
    resistance, (1 / GAMMA));

  return lux;
}

float lerUmidade() {
  TempAndHumidity data =
    dhtSensor.getTempAndHumidity();

  return data.humidity;
}


// -------- ENVIO HTTP --------

void enviarDados() {

  if (WiFi.status() == WL_CONNECTED) {

    float temp = lerTemperaturaNTC();
    float umid = lerUmidade();
    float lux  = lerLuminosidade();

    HTTPClient http;

    http.begin(serverURL);

    http.addHeader(
      "Content-Type",
      "application/json"
    );

    String json = "{";
    json += "\"temperatura\":" + String(temp, 2) + ",";
    json += "\"umidade\":" + String(umid, 1) + ",";
    json += "\"luminosidade\":" + String(lux, 2);
    json += "}";

    int httpResponseCode =
      http.POST(json);

    if (httpResponseCode > 0) {

      Serial.print("HTTP: ");
      Serial.println(httpResponseCode);

      String resposta =
        http.getString();

      Serial.println(resposta);

    } else {

      Serial.print("Erro HTTP: ");
      Serial.println(httpResponseCode);

    }

    http.end();
  }
}


// -------- SETUP --------

void setup() {

  Serial.begin(9600);

  WiFi.begin(ssid, pwd);

  dhtSensor.setup(
    DHT_PIN,
    DHTesp::DHT22
  );

  Serial.print("Conectando WiFi");

  while (WiFi.status() != WL_CONNECTED) {

    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi conectado!");
}


// -------- LOOP --------

void loop() {

  enviarDados();

  delay(10000);
}