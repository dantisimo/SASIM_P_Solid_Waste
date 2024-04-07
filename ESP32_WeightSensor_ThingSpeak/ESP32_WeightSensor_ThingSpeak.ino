#include <HX711.h>

#include <WiFi.h>

#include <HTTPClient.h>

// HX711 circuit wiring
HX711 scale;

uint8_t dataPin = 6;
uint8_t clockPin = 7;

const char* ssid = "Dante_Internet";

const char* password = "NewtonRaphson";

// Domain Name with full URL Path for HTTP POST Request

const char* serverName = "http://api.thingspeak.com/update";

// write API Key provided by thingspeak

String apiKey = "8RLDTUI1VDWC1CJ9";

float Weight;

void setup() {

  Serial.begin(115200);

  WiFi.begin(ssid, password);

  Serial.println(__FILE__);
  Serial.print("LIBRARY VERSION: ");
  Serial.println(HX711_LIB_VERSION);
  Serial.println();

  scale.begin(dataPin, clockPin);

  // TODO find a nice solution for this calibration..
  // load cell factor 20 KG
  // scale.set_scale(127.15);

  // load cell factor 5 KG
  scale.set_scale(420.0983);       // TODO you need to calibrate this yourself.
  // reset the scale to zero = 0
  scale.tare(20);


  Serial.println("Connecting");

  while(WiFi.status() != WL_CONNECTED) {

    delay(500);

    Serial.print(".");

  }

  Serial.println("");

  Serial.print("Connected to WiFi network with IP Address: ");

  Serial.println(WiFi.localIP());

}

void loop() {

  if(WiFi.status()== WL_CONNECTED){

      WiFiClient client;

      HTTPClient http;

      delay(30000); // wait for 30 seconds
      

      if (scale.is_ready()){
     Weight = scale.get_units(1);
    }

      if (isnan(Weight)) {

       Serial.println(F("Failed to read from HX711 sensor!"));

       return;

      }
   

      // Your Domain name with URL path or IP address with path

      http.begin(client, serverName);


      // Specify content-type header

      http.addHeader("Content-Type", "application/x-www-form-urlencoded");

      // Data to send with HTTP POST

      String httpRequestData = "api_key=" + apiKey + "&field1=" + String(Weight);          

      // Send HTTP POST request

      int httpResponseCode = http.POST(httpRequestData);

     // Data to send with HTTP POST

      httpRequestData = "api_key=" + apiKey + "&field2=" + "0.1";          

      // Send HTTP POST request

      httpResponseCode = http.POST(httpRequestData);

     

      Serial.print("HTTP Response code: ");

      Serial.println(httpResponseCode);

 

      http.end();

    }

    else {

      Serial.println("WiFi Disconnected");

    }

}