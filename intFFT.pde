//レイアウト
int MARGIN=80;       //余白

Area graph_area = new Area(
  MARGIN, MARGIN, 600, 400
  );

//波
//                 A   f    信号長
Wave wave=new Wave(20, 100, 2048);

void settings() {
  size(MARGIN+graph_area.get_width(), MARGIN*2+graph_area.get_height());
}

void setup() {
  //wave.generateWave();
}

void draw() {
  background(220);

  graph_area.bg(255);
}