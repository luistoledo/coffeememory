import processing.serial.*;

public class Sensor {
  PApplet sketch;
  Serial serial;
  
  int sensor1 = 0;
  int sensor2 = 0;
  int sensor3 = 0;
  int sensor4 = 0;
  int sensor5 = 0;
  int sensor6 = 0;

  String raw = "not connected";
  
  int threshold = 50;
  Boolean s1 = false;
  Boolean s2 = false;
  Boolean s3 = false;
  Boolean s4 = false;
  Boolean s5 = false;
  Boolean s6 = false;
  Boolean ps1 = false;
  Boolean ps2 = false;
  Boolean ps3 = false;
  Boolean ps4 = false;
  Boolean ps5 = false;
  Boolean ps6 = false;

  SerialProxy serialProxy;

  Sensor(PApplet s, int portNumber, int threshold) {
    print("serial ports: ");
    println(Serial.list());

    this.sketch = s;
    this.serialProxy = new SerialProxy();
    sketch.registerMethod("dispose", this);
    connect(portNumber);
    this.threshold = threshold;
  }
  
  public void dispose(){
    this.serial.dispose();
  }

  void connect(int portNumber) {
    String portName = Serial.list()[portNumber];
    println("selected port: "+portName);
    serial = new Serial(this.serialProxy, portName, 9600);
    serial.bufferUntil('\n');
    println("serial connection to "+portName+" done");
  }

  public class SerialProxy extends PApplet {
     // public SerialProxy() {
     // }
    public void serialEvent(Serial which) {
      try {
        while (which.available() > 0) {
          raw = which.readString().trim();
          sensor1 = int(split(raw, ",")[0]);
          sensor2 = int(split(raw, ",")[1]);
          sensor3 = int(split(raw, ",")[2]);
          sensor4 = int(split(raw, ",")[3]);
          sensor5 = int(split(raw, ",")[4]);
          sensor6 = int(split(raw, ",")[5]);
          
          ps1 = s1;
          s1 = sensor1 > threshold;
          ps2 = s2;
          s2 = sensor2 > threshold;
          ps3 = s3;
          s3 = sensor3 > threshold;
          ps4 = s4;
          s4 = sensor4 > threshold;
          ps5 = s5;
          s5 = sensor5 > threshold;
          ps6 = s6;
          s6 = sensor6 > threshold;
        }
      } 
      catch (Exception e) {
        e.printStackTrace();
        throw new RuntimeException("Error inside serialEvent()");
      }
    }
  }
}