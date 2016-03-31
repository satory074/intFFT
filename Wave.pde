class Wave {
  private int fs = 44100; //標本化周波数
  
  private int a;//最大振幅
  private int f;//振動数
  private int signal_length;//信号長
  
  SyntheticWave synthetic;
  
  private int[] amplitude;//振幅

  public Wave(int a, int f, int signal_length) {
    this.a = a;
    this.f = f;
    this.signal_length = signal_length;
    
    amplitude = new int[this.signal_length];
    
    for (int k=0; k<signal_length; k++) {
      this.amplitude[k] = round(-this.a*sin(2*PI*this.f*k/fs));
    }
    
    synthetic = new SyntheticWave(this);
  }


  public SyntheticWave get_synthetic(){
    return this.synthetic;
  }

  public int getSignalLength() {
    return this.signal_length;
  }
  
  public int[] get_amplitude(){
    return this.amplitude; //<>//
  }
  
  public int get_amplitude(int n){
    return this.amplitude[n];
  }
  
  public int get_a(){
    return this.a;
  }
  
  public int get_f(){
    return this.f;
  }
  
  public int get_fs(){
    return this.fs;
  }
}