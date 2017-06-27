class ScreensData {
  ScreenData pan;
  ScreenData mug;
  ScreenData cup;

  ScreensData(JSONArray data) {
    this.pan = new ScreenData (data.getJSONObject(0));
    this.mug = new ScreenData (data.getJSONObject(1));
    this.cup = new ScreenData (data.getJSONObject(2));
  }
}

class ScreenData {
  String id;
  int x;
  int y;
  int w;
  int h;
  int radius;

  ScreenData(JSONObject data) {
    this.id = data.getString("id");
    this.x = data.getInt("x");
    this.y = data.getInt("y");
    this.w = data.getInt("w");
    this.h = data.getInt("h");
    this.radius = data.getInt("radius");
  }
}