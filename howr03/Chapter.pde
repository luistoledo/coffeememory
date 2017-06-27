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
    pan = new Screen(sketch, data.panVideo, data.panVideoOverlay, screensData.pan);
    mug = new Screen(sketch, data.mugVideo, data.mugVideoOverlay, screensData.mug);
    cup = new Screen(sketch, data.cupVideo, data.cupVideoOverlay, screensData.cup);

    // longestVideoDuration = max( pan.duration(), mug.duration(), cup.duration() );

    looping = data.looping;
    proximityThreshold = data.proximityThreshold;
    proximityMinimumtime = data.proximityMinimumtime;
    proximityMinimumtimeCounter = 0;
    distortThreshold = data.distortThreshold;
    proximityQuantity = data.proximityQuantity;
  }

  void draw() {
    pan.draw();
    mug.draw();
    cup.draw();
  }

  void start(){
    pan.start(looping);
    mug.start(looping);
    cup.start(looping);
  }

  void stop(){
    pan.stop();
    mug.stop();
    cup.stop();
  }

  Boolean isEnded(){
    //&& pan.isEnded() && pan.isEnded();
    // return pan.isEnded(); 
    // return cup.isEnded(); 
    // return pan.isEnded() && cup.isEnded();
    return pan.isEnded() && cup.isEnded() && mug.isEnded();
  }

  void distort(int value) {
    pan.distort(value);
    mug.distort(value);
    cup.distort(value);
  }


}
