/**
 * 波
 * @author satory
 *
 */
class Wave {
  private int FS = 44100; //標本化周波数
  private int a;//最大振幅
  private int f;//振動数
  private int signal_length;//信号長
  
  private int[] amplitude;//振幅
  
  private SyntheticWave synthetic;//合成波


  public Wave(int a, int f, int signal_length) {        
    this.a = a;
    this.f = f;
    this.signal_length = signal_length;
    
    //sin波の生成
    amplitude = new int[this.signal_length];
    for (int k=0; k<signal_length; k++) {
      this.amplitude[k] = round(-this.a*sin(2*PI*this.f*k/FS));
    }
    
    synthetic = new SyntheticWave(this);
  }


  /*---Getter--*/
  
  public int get_fs(){
    return this.FS;
  }

  public int get_a(){
    return this.a;
  }
  
  public int get_f(){
    return this.f;
  }

  public int get_signal_length() {
    return this.signal_length;
  }
  
  public int[] get_amplitude(){
    return this.amplitude; //<>//
  }
  
  public int get_amplitude(int n){
    return this.amplitude[n];
  }
  
  /**
   * 合成波の振幅のint配列を返す
   *
   * @param  (String) 波の種類
   * @return (int[] ) 振幅のint配列
   *
   */
  public int[] get_synthetic(String wave_name){
    switch(wave_name){
      case "square":
        return this.synthetic.get_square_amplitude();
      case "sawtooth":
        return this.synthetic.get_square_amplitude();
      case "triangle":
        return this.synthetic.get_square_amplitude();
      default:
        return this.synthetic.get_square_amplitude();
    }
  }
}