boolean debug = false;
boolean USERSENSOR = true;
boolean FULLSCREEN = true;

static final int CHAPTER_OUTSIDE = 0;
static final int CHAPTER_INSIDE  = 1;

Chapter outside;
Chapter inside;

int current;

Sensor sensor;
Proximity proximity;

void settings(){
  if (FULLSCREEN)
    fullScreen();
  else
    size(400, 600, P2D);
}

void setup(){
  JSONObject jsonData = loadJSONObject("config.json");

  ScreensData screensData = new ScreensData(jsonData.getJSONArray("screens"));
  ChapterData outsideData = new ChapterData(jsonData.getJSONObject("chapter_outside"));
  ChapterData insideData  = new ChapterData(jsonData.getJSONObject("chapter_inside"));

  // second parameter: arduino usb port
  sensor = new Sensor(this, 2, insideData.distortThreshold);
  // second parameter: camera index. 10:size=160x90,fps=15
  proximity = new Proximity(this, 10);

  outside = new Chapter(this, outsideData, screensData);
  inside  = new Chapter(this, insideData, screensData);

  outside.start();
  this.current = CHAPTER_OUTSIDE;

  println("setup complete");
}

void draw(){
  if (inside.pan.distortRamp>0) {
    fill(0,0,0,10);
    rect(0,0,width,height);
  }else {
    background(0);
  }
  
  if (debug) {
    pushStyle();
    stroke(100,250,100);
    noFill();
    rect(0,0,width-1,height-1);
    popStyle();
  }

  if (this.current==CHAPTER_OUTSIDE) {
    outside.draw();

     if (proximity.detect(outside.proximityThreshold, outside.proximityQuantity)) {
      outside.proximityMinimumtimeCounter++;
      if (outside.proximityMinimumtimeCounter > outside.proximityMinimumtime) {
        outside.stop();
        inside.start();
        this.current = CHAPTER_INSIDE;
        outside.proximityMinimumtimeCounter = 0;
        println("change chapter to inside");
      }
    } else {
      outside.proximityMinimumtimeCounter = 0;
     }

    if (debug) {
      pushStyle();
      stroke(100,250,100);
      fill(100,100,100);
      
      float d = map(outside.proximityMinimumtimeCounter, 0.0, outside.proximityMinimumtime, 0.0, 100);
      rect(268+33, 120, 100, 10);
      fill(100,250,100);
      rect(268+33, 120, d, 10);
      text("duration: "+outside.proximityMinimumtimeCounter, 268,120);
      popStyle();
    }
  }

  if (this.current==CHAPTER_INSIDE) {
    inside.draw();

    if (sensor.s1) {
      inside.distort(sensor.sensor1);
      // println(sensor.sensor2);
    }

    if (inside.isEnded()) {
        inside.stop();
        outside.start();
        proximity.setBGReference();
        this.current = CHAPTER_OUTSIDE;
        println("change chapter to outside");
    }

    if (debug) {
      pushStyle();
      stroke(100,250,100);
      fill(100,250,100);
      text("sensor: "+sensor.raw, 0, 10);
      String[]r = split(sensor.raw, ',');
      for (int i=0;i<r.length;i++) {
        text("sensor "+i+": "+r[i], 0, 20+(i*10));
      }
      popStyle();
    }
  }

  if (debug) {
    String c = "inside";
    if (this.current==CHAPTER_OUTSIDE) c = "outside";
    pushStyle();
    stroke(100,250,100);
    fill(100,250,100);
    text("chapter:  "+c, 0, height-20);
    text("sensor: "+sensor.raw, 0, height-10);
    popStyle();
  }
  if (sensor.raw == "not connected") {
    text("sensor not working restart app and/or restart arduino", 0, 10);
  }
}


void keyPressed(){
  if (keyCode == TAB) {
    debug = !debug;
    println("debug: ", debug);
  }
 
  //if (key == 'r') {
  //  setup();
  //}
  
  if (key == '1') {
     proximity.setBGReference();
  }

  if (key == '2') {
    sensor.s1 = true;
    sensor.sensor1 += 5;
  }
  if (key == '0') {
    sensor.s1 = false;
    sensor.sensor1 = 0;
  }
}

void mousePressed() {
  if (mouseButton==LEFT)
    debug = !debug;

  if (mouseButton==RIGHT)
    exit();
}

public void movieEvent(Movie m) {
  m.read();
}

public void captureEvent(Capture c) {
  c.read();
  proximity.forceSetBGReference();
}