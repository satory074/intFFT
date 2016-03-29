class Wave {
  private int a;//振幅
  private int f;//振動数
  private int T;//周期
  private int fs; //標本化周波数
  private int signal_length;//信号長

  private int[] amplitude;
  private int DFTSize;
  private boolean isFFT;
  private boolean hasFFT;
  private boolean hasGenerate;

  private int[] visible_real;
  private int[] sine_real;
  private int[] square_real;
  private int[] sawtooth_real;
  private int[] triangle_real;
  private int[] imag;

  public Wave(int a, int f, int fs, int signal_length) {
    this.a=a;
    this.f=f;
    this.T=1/f;
    this.fs=fs;
    this.signal_length=signal_length;

    this.DFTSize=2048;
    this.amplitude    = new int[this.DFTSize];
    this.visible_real = new int[this.signal_length];
    this.sine_real    = new int[this.signal_length];
    this.square_real  = new int[this.signal_length];
    this.sawtooth_real= new int[this.signal_length];
    this.triangle_real= new int[this.signal_length];
    this.imag         = new int[this.signal_length];
  }

  public int[] getVisibleReal() {
    return this.visible_real;
  }

  public int[] getSineReal() {
    return this.sine_real;
  }

  public int[] getSquareReal() {
    return this.square_real;
  }

  public int[] getSawtoothReal() {
    return this.sawtooth_real;
  }

  public int[] getTriangleReal() {
    return this.triangle_real;
  }

  public int[] getImag() {
    return this.imag;
  }

  public int getSignalLength() {
    return this.signal_length;
  }

  public int getDFTSize() {
    return this.DFTSize;
  }

  public int[] getAmplitude() {
    return this.amplitude;
  }

  public boolean getHasFFT() {
    return this.hasFFT;
  }

  public boolean getIsFFT() {
    return this.isFFT;
  }

  public boolean getHasGenerate() {
    return this.hasGenerate;
  }

  public void setVisibleWave(String s) {
    switch(s) {
    case "sine":
      this.visible_real=this.sine_real;
      break;
    case "square":
      this.visible_real=this.square_real;
      break;
    case "sawtooth":
      this.visible_real=this.sawtooth_real;
      break;
    case "triangle":
      this.visible_real=this.triangle_real;
      break;
    }
  }

  public void generateWave() {
    this.sine_real     = new int[signal_length];
    this.square_real   = new int[signal_length];
    this.sawtooth_real = new int[signal_length];
    this.triangle_real = new int[signal_length];

    for (int k=0; k<signal_length; k++) {
      //sin波
      this.sine_real[k]=(int)(-this.a*sin(2*PI*this.f*k/fs));

      for (int i=0; i<100; i++) {
        //矩形波
        this.square_real[k]+=(int)((-this.a/(2*i+1))*sin(2*PI*this.f*k*(2*i+1)/fs));
        //のこぎり波
        this.sawtooth_real[k]+=(int)((-this.a/(2*i+2))*sin(2*PI*this.f*k*(2*i+2)/fs));
        //三角波
        this.triangle_real[k]+=pow((-1), i)*(int)((-this.a/sq(2*i+1))*sin(2*PI*this.f*k*(2*i+1)/fs));
      }
    }

    this.hasGenerate=true;
  }


  void doFFT(int x_real[], int x_imag[], int N) {
    this.isFFT=true;

    int i, j, k, n, m, r, stage, number_of_stage;
    int[] index;
    int a_real, a_imag, b_real, b_imag, c_real, c_imag, real, imag;

    int[] FFTreal = new int[x_real.length];
    int[] FFTimag = new int[x_imag.length];

    for (i=0; i<x_real.length; i++) {
      FFTreal[i]=x_real[i];
      FFTimag[i]=x_imag[i];
    }

    //FFTの段数
    number_of_stage = (int)(log(N)/log(2));

    int[] sine_table=mt.get_sine_table();
    int[] cosine_table=mt.get_cosine_table();

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
          //c_real = (int)(32767*cos((2.0 * PI * r) / N));
          //c_imag = (int)(32767*-sin((2.0 * PI * r) / N));
          c_real=cosine_table[r];
          c_imag=sine_table[r];


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
    for (int kk=0; kk<amplitude.length; kk++) {
      this.amplitude[kk]=(int)sqrt(pow(FFTreal[kk], 2)+pow(FFTimag[kk], 2));
    }

    this.isFFT=false;
    this.hasFFT=true;
  }
}