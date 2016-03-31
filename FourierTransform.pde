class FourierTransform{
  private int WINDOW_SIZE = 2048;
  private ArrayList<String> c_data = new ArrayList();
  
  private Wave wave;
  
  private int[] spectrum;
    
  FourierTransform(Wave wave){
    this.wave = wave;
    
    this.spectrum = new int[this.WINDOW_SIZE];
  }
  
  public Wave get_wave(){
    return this.wave;
  }
  
  public int get_WINDOW_SIZE(){
    return this.WINDOW_SIZE;
  }
  
  public int[] get_spectrum(){
    return this.spectrum;
  }
  
  public int get_spectrum(int n){
    return this.spectrum[n];
  }


  public void fft(int[] x_r, int[] x_imag) {
    int i, j, k, n, m, r, stage, number_of_stage;
    int[] index;
    int a_real, a_imag, b_real, b_imag, c_real, c_imag, real, imag;

    int[] x_real = new int[this.WINDOW_SIZE];
    for(int ii=0; ii<this.WINDOW_SIZE; ii++){
      x_real[ii] = x_r[ii];
    }
    
    int count= 0;

    //FFTの段数
    number_of_stage = (int)(log(this.WINDOW_SIZE)/log(2));

    //バタフライ計算
    for (stage = 1; stage <= number_of_stage; stage++) {
      for (i = 0; i < pow(2, stage - 1); i++) {
        for (j = 0; j < pow(2, number_of_stage - stage); j++) {
          n = (int)pow(2, number_of_stage - stage + 1) * i + j;
          m = (int)pow(2, number_of_stage - stage) + n;
          r = (int)pow(2, stage - 1) * j;
          a_real = x_real[n];
          a_imag = x_imag[n];
          b_real = x_real[m];
          b_imag = x_imag[m];
          c_real = (int)(round((127*cos((2.0 * PI * r) / this.WINDOW_SIZE))));
          c_imag = (int)(round((127*(-sin((2.0 * PI * r) / this.WINDOW_SIZE)))));;         
          this.c_data.add(str(c_real));
          
          if (stage < number_of_stage) {
            x_real[n] = (a_real + b_real);
            x_imag[n] = (a_imag + b_imag);
            x_real[m] =((a_real - b_real) * c_real - (a_imag - b_imag) * c_imag)>>6;
            x_imag[m] =((a_imag - b_imag) * c_real + (a_real - b_real) * c_imag)>>6;
          } else {
            x_real[n] = (a_real + b_real);
            x_imag[n] = (a_imag + b_imag);
            x_real[m] = (a_real - b_real);
            x_imag[m] = (a_imag - b_imag);
          }
        }
      }
    }

    //インデックスの並び替えのためのテーブルの作成
    index = new int[this.WINDOW_SIZE];
    
    for (stage = 1; stage <= number_of_stage; stage++) {
      for (i = 0; i < pow(2, stage - 1); i++) {
        index[(int)pow(2, stage - 1) + i] = index[i] + (int)pow(2, number_of_stage - stage);
      }
    }

    //インデックスの並び替え
    for (k = 0; k < this.WINDOW_SIZE; k++) {
      if (index[k] > k) {
        real = x_real[index[k]];
        imag = x_imag[index[k]];
        x_real[index[k]] = x_real[k];
        x_imag[index[k]] = x_imag[k];
        x_real[k] = real;
        x_imag[k] = imag;
      }
    }
    for (int kk=0; kk<this.spectrum.length; kk++) {
      this.spectrum[kk]=(int)sqrt(pow(x_real[kk], 2)+pow(x_imag[kk], 2));
    }
    
    saveStrings("data.txt", (String[])this.c_data.toArray(new String[0]));
  }

/* 
   public void fft(int[] x_r, float[] x_imag) {
    int i, j, k, n, m, r, stage, number_of_stage;
    int[] index;
    float a_real, a_imag, b_real, b_imag; 
    float c_real, c_imag, real, imag;
    
    float[] x_real = new float[this.WINDOW_SIZE];
    for(int ii=0; ii<this.WINDOW_SIZE; ii++){
      x_real[ii] = x_r[ii];
    }
    

    //FFTの段数
    number_of_stage = (int)(log(this.WINDOW_SIZE)/log(2));

    //バタフライ計算
    for (stage = 1; stage <= number_of_stage; stage++) {
      for (i = 0; i < pow(2, stage - 1); i++) {
        for (j = 0; j < pow(2, number_of_stage - stage); j++) {
          n = (int)pow(2, number_of_stage - stage + 1) * i + j;
          m = (int)pow(2, number_of_stage - stage) + n;
          r = (int)pow(2, stage - 1) * j;
          a_real = x_real[n];
          a_imag = x_imag[n];
          b_real = x_real[m];
          b_imag = x_imag[m];
          c_real = cos((2.0 * PI * r) / this.WINDOW_SIZE);
          c_imag = -sin((2.0 * PI * r) / this.WINDOW_SIZE);
          
          this.c_data.add(nf(a_real,2,2));

          if (stage < number_of_stage) {
            x_real[n] = (a_real + b_real);
            x_imag[n] = (a_imag + b_imag);
            x_real[m] =((a_real - b_real) * c_real - (a_imag - b_imag) * c_imag);
            x_imag[m] =((a_imag - b_imag) * c_real + (a_real - b_real) * c_imag);
          } else {
            x_real[n] = (a_real + b_real);
            x_imag[n] = (a_imag + b_imag);
            x_real[m] = (a_real - b_real);
            x_imag[m] = (a_imag - b_imag);
          }
        }
      }
    }

    //インデックスの並び替えのためのテーブルの作成
    index = new int[this.WINDOW_SIZE];
    
    for (stage = 1; stage <= number_of_stage; stage++) {
      for (i = 0; i < pow(2, stage - 1); i++) {
        index[(int)pow(2, stage - 1) + i] = index[i] + (int)pow(2, number_of_stage - stage);
      }
    }

    //インデックスの並び替え
    for (k = 0; k < this.WINDOW_SIZE; k++) {
      if (index[k] > k) {
        real = x_real[index[k]];
        imag = x_imag[index[k]];
        x_real[index[k]] = x_real[k];
        x_imag[index[k]] = x_imag[k];
        x_real[k] = real;
        x_imag[k] = imag;
      }
    }
    for (int kk=0; kk<this.spectrum.length; kk++) {
      this.spectrum[kk]=(int)sqrt(pow(x_real[kk], 2)+pow(x_imag[kk], 2));
    }
    saveStrings("data.txt", (String[])this.c_data.toArray(new String[0]));
  }
 */
}