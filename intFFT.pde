boolean DEBUG_MODE = true;
boolean INT_MODE = true;

String WAVE_NAME = "sine";//処理する波

//              Wave(  A  ,  f , 信号長)
Wave wave = new Wave(30000, 440, 2048  );

FourierTransform ft = new FourierTransform();


void setup() {
  //fft
  if(INT_MODE) ft.int_fft(wave.get_synthetic(WAVE_NAME));
    else ft.fft(wave.get_synthetic(WAVE_NAME));
  
  //fftの結果をコンソールに出力
  if(DEBUG_MODE) ft.print_spectrum();
  
  exit();
}