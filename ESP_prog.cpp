#include "DHTesp.h"
DHTesp dhtSensor;

void setup() {
  Serial.begin(9600);
  dhtSensor.setup(DHT_PIN, DHTesp::DHT22);
}
void temperatura(){
  const float BETA = 3950;
  int analogValue = analogRead(15);
  float celsius = 1 / (log(1 / (1023. / analogValue - 1)) / BETA + 1.0 / 298.15) - 273.15;
  Serial.println("Temperatura: " + String(celsius, 2));
  Serial.println("---");
}
void luminosidade(){
  const float GAMMA = 0.7;
  const float RL10 = 50;
  int analogValue = analogRead(2);
  float voltage = analogValue / 1024. * 5;
  float resistance = 2000 * voltage / (1 - voltage / 5);
  float lux = pow(RL10 * 1e3 * pow(10, GAMMA) / resistance, (1 / GAMMA));
  Serial.println("Lux: " + String(lux, 2));
  Serial.println("---");
}
void umidade(){
  const int DHT_PIN = 16;
  TempAndHumidity  data = dhtSensor.getTempAndHumidity();
  Serial.println("Temp: " + String(data.temperature, 2) + "°C");
  Serial.println("Humidity: " + String(data.humidity, 1) + "%");
  Serial.println("---");
}
void loop() {
  temperatura();
  luminosidade();
  umidade();
}
