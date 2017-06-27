import processing.video.*;

class Proximity {
  Capture cam;
  PImage bgRef;
  PImage debugImg;

  Boolean shouldTakeRef = false;

  Proximity(PApplet sketch, int cameraIndex) {
    String[] cameras = Capture.list();
    print("cameras: ");
    println(cameras);

    cam = new Capture(sketch, cameras[cameraIndex]);
    cam.start();

    while(cam.available()){}
    setBGReference();
  }

  public Boolean detect(int threshold, int quantity) {
    int d = bGSubstraction(threshold);
    return d > quantity;
  }

  // compare bgRef with actual frame
  int bGSubstraction(int threshold){
    if (bgRef==null) setBGReference();
    if (bgRef==null) return 0;
    int diff = 0;

    // debugImg = cam;
    cam.read();
    debugImg = createImage(169, 90, RGB);
    debugImg = cam.copy();
    
    cam.loadPixels();
    debugImg.loadPixels();
    bgRef.loadPixels();

    for (int i=0; i<cam.pixels.length; i++) {
      color currentColor = cam.pixels[i];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = bgRef.pixels[i];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);
      float d = distSq(r1, g1, b1, r2, g2, b2); 

      if (d > threshold*threshold) {
        diff++;
        debugImg.pixels[i] = 0;
      }
    }
    debugImg.updatePixels();

    if (debug) {
      pushStyle();
      image(bgRef, 0,0,133,100);
      image(cam, 134,0,133,100);
      image(debugImg, 268,0,133,100);
      fill(100,250,100);
      text("diff: "+diff, 268,110);
      popStyle();
    }

    return diff;
  }

  public void setBGReference() {
    shouldTakeRef = true;
  }

  public void forceSetBGReference() {
    if (shouldTakeRef) {
      bgRef = cam.copy();
      bgRef.updatePixels();
      println("background reference updated");
      shouldTakeRef = false;
    }
  }

}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}