class SyntheticWave {
  Wave wave;
  
  private int[] visible_real;
  private int[] sine_real;
  private int[] square;
  private int[] sawtooth;
  private int[] triangle;
  private int[] imag;
  
  private int approx = 100;
  
  SyntheticWave(Wave wave){ 
    this.wave = wave;
    
    square   = new int[this.wave.getSignalLength()];
    sawtooth = new int[this.wave.getSignalLength()];
    triangle = new int[this.wave.getSignalLength()];
    
    for (int k=0; k<wave.getSignalLength(); k++) {
      for (int i=0; i<approx; i++) {
        //矩形波
        this.square[k]  +=(int)((-this.wave.get_a()/(2*i+1))*sin(2.0*PI*this.wave.get_f()*k*(2*i+1)/this.wave.get_fs()));
        //のこぎり波
        this.sawtooth[k]+=(int)((-this.wave.get_a()/(i+1))*sin(2.0*PI*this.wave.get_f()*k*(i+1)/this.wave.get_fs()));
        //三角波
        this.triangle[k]+=pow((-1), i)*(int)((-this.wave.get_a()/sq(2*i+1))*sin(2.0*PI*this.wave.get_f()*k*(2*i+1)/this.wave.get_fs()));
      }
    }
  }

  public int[] get_square(){
    return this.square;
  }
  
  public int[] get_sawtooth(){
    return this.sawtooth;
  }
  
  public int[] get_triangle(){
    return this.triangle;
  }
}