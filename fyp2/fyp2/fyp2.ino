#include <ZMPT101B.h>
#include <WiFi.h>         // Include the WiFi library
#include <ArduinoHttpClient.h> // Include the ArduinoHttpClient library
#include <EEPROM.h>
#include "Irms_Calc.h"
#include "ArduinoGraphics.h"
#include "Arduino_LED_Matrix.h"

#define ACTUAL_VOLTAGE 225.0f // Change this based on actual voltage

#define START_VALUE 100.0f
#define STOP_VALUE 1400.0f
#define STEP_VALUE 0.25f
#define TOLLERANCE 1.0f

#define MAX_TOLLERANCE_VOLTAGE (ACTUAL_VOLTAGE + TOLLERANCE)
#define MIN_TOLLERANCE_VOLTAGE (ACTUAL_VOLTAGE - TOLLERANCE)

const char* ssid = "Asus_Deco";
const char* password = "hafeezhakeem";
const char* serverAddress = "192.168.1.24"; // Update with your server address
const int serverPort = 10000; // Update with your server port if different

float voltage = 0;
bool isValidVoltage = false;

// ZMPT101B sensor output connected to analog pin A0
// and the voltage source frequency is 50 Hz.
const float Voltage_SENSITIVITY = 1147.5;
ZMPT101B voltageSensor(A0, 50.0);

const int sensorIn = A1;
ACS712_Irms acs712;

WiFiClient wifi;
HttpClient client = HttpClient(wifi, serverAddress, serverPort);
int status = WL_IDLE_STATUS;

void calibrate() {
    Serial.print("The Actual Voltage: ");
    Serial.println(ACTUAL_VOLTAGE);

    float senstivityValue = START_VALUE;
    voltageSensor.setSensitivity(senstivityValue);
    float voltageNow = voltageSensor.getRmsVoltage();

    Serial.println("Start calculate");

    while (voltageNow > MAX_TOLLERANCE_VOLTAGE || voltageNow < MIN_TOLLERANCE_VOLTAGE) {
        if (senstivityValue < STOP_VALUE) {
            senstivityValue += STEP_VALUE;
            voltageSensor.setSensitivity(senstivityValue);
            voltageNow = voltageSensor.getRmsVoltage();
            Serial.print(senstivityValue);
            Serial.print(" => ");
            Serial.println(voltageNow);
        } else {
            Serial.println("Unfortunately the sensitivity value cannot be determined");
            return;
        }
    }

    Serial.print("Closest voltage within tolerance: ");
    Serial.println(voltageNow);
    Serial.print("Sensitivity Value: ");
    Serial.println(senstivityValue, 10);
}

void setup() {
    Serial.begin(115200);
    
    // Initialize WiFi
    while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   // print the network name (SSID);

    // Connect to WPA/WPA2 network:
    status = WiFi.begin(ssid, password);
  }

  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);


  voltageSensor.setSensitivity(Voltage_SENSITIVITY);

    while (!isValidVoltage) {
        Serial.println("Reading voltage");
        voltage = voltageSensor.getRmsVoltage();
        if (voltage > 200) {
            isValidVoltage = true;
            Serial.println("Valid voltage: " + String(voltage));
        }
        delay(1000);
    }

    acs712.ADCSamples = 1024.0; // 1024 samples
    acs712.mVperAmp = scaleFactor::ACS712_5A; // use 100 for 20A Module, 66 for 30A Module, and 185 for 5A Module
    acs712.maxADCVolt = 5.0; // 5 Volts
    acs712.ADCIn = A1;
    acs712.Init(); 
}

unsigned long lastPostTime = 0;
    

void loop() {

 unsigned long currentTime = millis();

    double AmpsRMS = acs712.Process(voltage)-0.41;
    double power = voltage * AmpsRMS; // Calculate power

if (currentTime - lastPostTime >= 10000) {
        // Perform the POST request
        String postData = "{\"voltage\":" + String(voltage) + ",\"current\":" + String(AmpsRMS) + ",\"power\":" + String(power) + "}";
        String contentType = "application/json";

        // Send HTTP POST request
        Serial.println("Making POST request");
        client.post("/data3", contentType, postData);

        // Read the status code and body of the response
        int statusCode = client.responseStatusCode();
        String response = client.responseBody();

        Serial.print("Status code: ");
        Serial.println(statusCode);
        Serial.print("Response: ");
        Serial.println(response);

        // Update the last POST request time
        lastPostTime = currentTime;
    }
}


