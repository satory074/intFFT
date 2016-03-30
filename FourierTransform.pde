class FourierTransform{
  private int window_size = 2048;
  
  private int[] spectrum;
    
  FourierTransform(){
    this.spectrum = new int[this.window_size];
  }
  
  public int get_window_size(){
    return this.window_size;
  }
  
  void doFFT(int x_real[], int x_imag[], int N) {
    int i, j, k, n, m, r, stage, number_of_stage;
    int[] index;
    int a_real, a_imag, b_real, b_imag, c_real, c_imag, real, imag;

    int[] FFTreal=new int[x_real.length];
    int[] FFTimag=new int[x_imag.length];

    for (i=0; i<x_real.length; i++) {
      FFTreal[i]=x_real[i];
      FFTimag[i]=x_imag[i];
    }

    //FFTの段数
    number_of_stage = (int)(log(N)/log(2));

    //バタフライ計算
    for (stage = 1; stage <= number_of_stage; stage++) {
      for (i = 0; i < pow(2, stage - 1); i++) {
        for (j = 0; j < pow(2, number_of_stage - stage); j++) {
          n = (int)pow(2, number_of_stage - stage + 1) * i + j;
          m = (int)pow(2, number_of_stage - stage) + n;
          r = (int)pow(2, stage - 1) * j;
          a_real = FFTreal[n];
          a_imag = FFTimag[n];
          b_real = FFTreal[m];
          b_imag = FFTimag[m];
          c_real = (int)(32767*cos((2.0 * PI * r) / N));
          c_imag = (int)(32767*-sin((2.0 * PI * r) / N));

          if (stage < number_of_stage) {
            FFTreal[n] = (a_real + b_real)>>1;
            FFTimag[n] = (a_imag + b_imag)>>1;
            FFTreal[m] =((a_real - b_real) * c_real - (a_imag - b_imag) * c_imag)>>15;
            FFTimag[m] =((a_imag - b_imag) * c_real + (a_real - b_real) * c_imag)>>15;
          } else {
            FFTreal[n] = (a_real + b_real)>>1;
            FFTimag[n] = (a_imag + b_imag)>>1;
            FFTreal[m] = (a_real - b_real)>>1;
            FFTimag[m] = (a_imag - b_imag)>>1;
          }
        }
      }
    }

    /* インデックスの並び替えのためのテーブルの作成 */
    index = new int[N];
    for (stage = 1; stage <= number_of_stage; stage++) {
      for (i = 0; i < pow(2, stage - 1); i++) {
        index[(int)pow(2, stage - 1) + i] = index[i] + (int)pow(2, number_of_stage - stage);
      }
    }

    /* インデックスの並び替え */
    for (k = 0; k < N; k++) {
      if (index[k] > k) {
        real = FFTreal[index[k]];
        imag = FFTimag[index[k]];
        FFTreal[index[k]] = FFTreal[k];
        FFTimag[index[k]] = FFTimag[k];
        FFTreal[k] = real;
        FFTimag[k] = imag;
      }
    }
    for (int kk=0; kk<this.spectrum.length; kk++) {
      this.spectrum[kk]=(int)sqrt(pow(FFTreal[kk], 2)+pow(FFTimag[kk], 2));
    }
  }
}