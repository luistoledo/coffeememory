class ChapterData{
  String id;
  String panVideo;
  String mugVideo;
  String cupVideo;
  String panVideoOverlay;
  String mugVideoOverlay;
  String cupVideoOverlay;
  Boolean looping;

  int proximityThreshold;
  int proximityMinimumtime;
  int proximityQuantity;

  int distortThreshold;

  ChapterData(JSONObject data) {
    this.id = data.getString("id");
    
    this.panVideo = data.getString("pan_video");
    this.mugVideo = data.getString("mug_video");
    this.cupVideo = data.getString("cup_video");
    this.panVideoOverlay = data.getString("pan_video_overlay");
    this.mugVideoOverlay = data.getString("mug_video_overlay");
    this.cupVideoOverlay = data.getString("cup_video_overlay");
    
    this.looping = data.getBoolean("looping");

    this.proximityThreshold   = data.getInt("proximity_threshold");
    this.proximityMinimumtime = data.getInt("proximity_minimumtime");
    this.proximityQuantity    = data.getInt("proximity_quantity");

    this.distortThreshold = data.getInt("distort_threshold");
  }
}