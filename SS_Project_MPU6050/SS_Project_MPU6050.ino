#include "I2Cdev.h"
#include "MPU6050.h"

// Arduino Wire library is required if I2Cdev I2CDEV_ARDUINO_WIRE implementation
// is used in I2Cdev.h
#if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
    #include "Wire.h"
#endif

MPU6050 accelgyro;

int16_t ax, ay, az;
int16_t gx, gy, gz;

#define OUTPUT_READABLE_ACCELGYRO
#define SAMPLE_NUMBER 5000

#define LED_PIN 13
bool blinkState = false;
int state;
void setup() {
    // join I2C bus (I2Cdev library doesn't do this automatically)
    #if I2CDEV_IMPLEMENTATION == I2CDEV_ARDUINO_WIRE
        Wire.begin();
    #elif I2CDEV_IMPLEMENTATION == I2CDEV_BUILTIN_FASTWIRE
        Fastwire::setup(400, true);
    #endif

    // initialize serial communication
    // (38400 chosen because it works as well at 8MHz as it does at 16MHz, but
    // it's really up to you depending on your project)
    Serial.begin(38400);

    // initialize device
    //Serial.println("Initializing I2C devices...");
    accelgyro.initialize();
    pinMode(LED_PIN, OUTPUT);
    state = 0;
}

void loop() {
    if (state == 0){
      if (Serial.available()){
        char tt = Serial.read();
        if (tt == 'a') state = 1;
      }
    }
    else{
      while(Serial.available()){
        char tt = Serial.read();
      }
      for (int i=0;i<SAMPLE_NUMBER;i++){
        accelgyro.getAcceleration(&ax, &ay, &az);
        
        Serial.print("a/g:\t");
        Serial.print(ax); Serial.print("\t");
        Serial.print(ay); Serial.print("\t");
        Serial.println(az);
        
        blinkState = !blinkState;
        digitalWrite(LED_PIN, blinkState);
      }
      state = 0;
    }
    
}
