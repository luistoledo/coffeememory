/*
 * READ 6 ANALOG VALUES, AND SEND A LINE OF INTEGER VALUES SEPARATED BY COMMA
 * ANALOG PINS 0 TO 3 ARE SMOOTHED
 * 4 AND 5 ARE RAW
 */
#include <AnalogSmooth.h>

#define SENSOR0PIN 0
#define SENSOR1PIN 1
#define SENSOR2PIN 2
#define SENSOR3PIN 3
#define SENSOR4PIN 4
#define SENSOR5PIN 5

#define DEBUG true

int sensor0, sensor1, sensor2, sensor3, sensor4, sensor5;
AnalogSmooth asensor0 = AnalogSmooth();
AnalogSmooth asensor1 = AnalogSmooth();
AnalogSmooth asensor2 = AnalogSmooth();
//AnalogSmooth asensor3 = AnalogSmooth();

void setup() {
  AnalogSmooth asensor0 = AnalogSmooth();
  AnalogSmooth asensor1 = AnalogSmooth();
  AnalogSmooth asensor2 = AnalogSmooth();

  Serial.begin(9600);
  while (!Serial);
}

void loop() {
  sensor0 = asensor0.analogReadSmooth(SENSOR0PIN);
  sensor1 = asensor1.analogReadSmooth(SENSOR1PIN);
  sensor2 = asensor2.analogReadSmooth(SENSOR2PIN);
//  sensor3 = asensor3.analogReadSmooth(SENSOR3PIN);

//  sensor4 = analogRead(SENSOR4PIN);
//  sensor5 = analogRead(SENSOR5PIN);  

  Serial.print(sensor0);
  Serial.print(",");
  Serial.print(sensor1);
  Serial.print(",");
  Serial.print(sensor2);
//  Serial.print(",");
//  Serial.print(sensor3);
//  Serial.print(",");
//  Serial.print(sensor4);
//  Serial.print(",");
//  Serial.print(sensor5);
  Serial.println();

  delay(10);
}
