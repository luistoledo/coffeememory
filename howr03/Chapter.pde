class Chapter {

  Screen pan;
  Screen mug;
  Screen cup;

  Boolean looping;

  int proximityThreshold;
  int proximityMinimumtime;
  int proximityQuantity;
  int proximityMinimumtimeCounter;

  int distortThreshold;

  // int longestVideoDuration;

  Chapter(PApplet sketch, ChapterData data, ScreensData screensData) {
    this.pan = new Screen(sketch, data.panVideo, data.panVideoOverlay, screensData.pan);
    this.mug = new Screen(sketch, data.mugVideo, data.mugVideoOverlay, screensData.mug);
    this.cup = new Screen(sketch, data.cupVideo, data.cupVideoOverlay, screensData.cup);

    // longestVideoDuration = max( pan.duration(), mug.duration(), cup.duration() );

    this.looping = data.looping;
    this.proximityThreshold = data.proximityThreshold;
    this.proximityMinimumtime = data.proximityMinimumtime;
    this.proximityMinimumtimeCounter = 0;
    this.distortThreshold = data.distortThreshold;
    this.proximityQuantity = data.proximityQuantity;
  }

  void draw() {
    pan.draw();
    mug.draw();
    cup.draw();
  }

  void start(){
    pan.start(this.looping);
    mug.start(this.looping);
    cup.start(this.looping);
  }

  void stop(){
    pan.stop();
    mug.stop();
    cup.stop();
  }

  Boolean isEnded(){
    //if (this.looping) return false;
    //&& pan.isEnded() && pan.isEnded();
    // return pan.isEnded(); 
    // return cup.isEnded(); 
    // return pan.isEnded() && cup.isEnded();
    //return pan.isEnded() && cup.isEnded() && mug.isEnded();
    return pan.isEnded() && cup.isEnded() && mug.isEnded();
    // return pan.isEnded();
  }

  void distort(int value) {
    pan.distort(value);
    mug.distort(value);
    cup.distort(value);
  }


}