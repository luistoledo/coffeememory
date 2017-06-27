import processing.video.*;

class Screen{
  String id, file;
  Rect region;
  int maskRadius;
  
  Boolean looping = false;;
  Boolean enabled = false;
  Boolean ended = false;
  Boolean editing = false;
  
  int DISTORTIONLIMIT = 100;

  Movie video;
  Movie videoOverlay;
  PImage mask;

  private PApplet sketch;

  public int distortRamp = 0;

  Screen (PApplet sketch, String videoFile, String videoFileOverlay, ScreenData data) {
    this.sketch = sketch;
    this.region = new Rect(data.x, data.y, data.w, data.h);
    this.maskRadius = data.radius;
    this.id = data.id;
    this.file = videoFile;
    
    if (this.file.length()==0) {
      this.enabled = false;
      println(this.id+" has no video to load");
    } else {
      this.enabled = true;
      println("loading normal  video "+this.file+" into "+this.id);
      this.video  = new Movie(sketch, videoFile);
      
      println("loading overlay video "+this.file+" into "+this.id);
      this.videoOverlay  = new Movie(sketch, videoFileOverlay);
    }

    this.mask = loadImage("mask.png");
  }

  public void start(Boolean looping) {
    if (!this.enabled) return;

    this.video.stop();
    this.looping = looping;
    if (this.looping) {
      this.video.loop();
      this.videoOverlay.loop();
    }
    else{
      this.video.noLoop();
      this.videoOverlay.noLoop();
    }

    video.volume(1);
    videoOverlay.volume(0);
  }

  public void stop() {
    if (!this.enabled) return;

    this.video.stop();
    this.videoOverlay.stop();
  }

  public void pause() {
    if (!this.enabled) return;

    this.video.pause();
    this.videoOverlay.pause();
  }

  public void distort(int value) {
    if (!this.enabled) return;

    value = constrain(value, 0, 100);

    distortRamp += value;
    distortRamp = constrain(distortRamp, 0, DISTORTIONLIMIT);

    
    float v = map(distortRamp,0,DISTORTIONLIMIT,0,1);
    
    if (distortRamp<1) {
      distortRamp = 0;  // if distort is less than 1, stop distortions

      video.volume(0);
      videoOverlay.volume(1);

      videoOverlay.jump( video.time() );
    }
    else {
      video.volume(1);
      videoOverlay.volume(0);
    }

    /// make d a class variable
    /// make a transtition with d = lerp(d, map(dR), 0.5)
    float d = map(distortRamp, 0, DISTORTIONLIMIT, 1.5, 0.2);

    // println(distortRamp+"--"+value+"--"+d);
    // this.video.speed(d);
    // this.videoOverlay.speed(d);
  }


  float blending = 0;

  void draw() {
    if (this.enabled) {

      distortRamp--;
      distortRamp = constrain(distortRamp, 0, distortRamp);

      pushStyle();
      
      blending = lerp(map (distortRamp, 0, DISTORTIONLIMIT, 0, 1), blending, 0.1);

      tint(255, (1-blending) * 255);
      image(video, region.x, region.y, region.w, region.w/1.87);
      
      tint(255, blending * 255);
      image(videoOverlay, region.x, region.y, region.w, region.w/1.87);


      popStyle();

      image(mask, region.x, region.y, region.w, region.w/1.87);

      if (!looping) {
        this.ended = video.time() > video.duration();
      }

    }
    else {
      pushStyle();
      fill(0);
      rect(region.x, region.y, region.w, region.w/1.87);
      popStyle();
    }
    if (debug) drawDebug();
  }


  // ???
  public Boolean isEnded(){
    if (!this.enabled) return false;

    return video.time() > video.duration()-1;
  }


  private void drawDebug() {
    pushStyle();
    stroke(100,250,100);
    fill(100,100,100);
    
    rect(region.x, region.y+region.h, region.w, 10);
    
    float d = 0;
    if (this.enabled)
      d = map(video.time(), 0.0, video.duration(), 0.0, region.w);
    else 
      d = 0;

    fill(100,250,100);
    rect(region.x, region.y+region.h, d, 10);

    text("screen:  "+this.id, region.x, region.y+region.h+20);

    if (!this.enabled) {popStyle(); return;}

    text("video:   "+this.file, region.x, region.y+region.h+30);
    text("distort: "+this.distortRamp, region.x, region.y+region.h+40);
    text("enabled: "+this.enabled, region.x, region.y+region.h+50);

    stroke(100,250,100);
    noFill();
    rect(region.x, region.y, region.w, region.w/1.86);
    ellipse(region.x+2+(region.w/2), region.y+(region.w/1.85/2), region.w/1.85, region.w/1.85);

    popStyle();
  }
}








class Rect {
  public int x, y, w, h;
  Rect() {
    this(0,0,0,0);
  }
  
  Rect(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}