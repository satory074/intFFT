//レイアウト
int MARGIN=80;       //余白

Area graph_area = new Area(
  MARGIN, MARGIN, 600, 400
  );

//波
//A   f    信号長
Wave wave = new Wave(30000, 4410, 2048);
FourierTransform ft = new FourierTransform(wave);

void settings() {
  size(MARGIN + graph_area.get_width(), MARGIN*2 + graph_area.get_height());
}

void setup() {
  //float[] imag = new float[wave.getSignalLength()];
  int[] imag = new int[wave.getSignalLength()];

  ft.fft(wave.get_amplitude(), imag);

  //println(ft.get_wave().get_amplitude());
  //println(ft.get_wave().get_amplitude());

  for(int i=0; i<ft.get_WINDOW_SIZE(); i++)
   println(ft.get_spectrum(i)+"");
}

void draw() {
  background(220);

  graph_area.bg(255);
}