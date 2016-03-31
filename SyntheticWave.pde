/**
 * 合成波
 *   Waveクラスに使われる
 *
 * @author satory
 */
class SyntheticWave{
  private Wave wave;
  
  private int wave_a;
  private int wave_f;
  private int wave_signal_length;
  private int wave_fs;
  
  private int[] square_amplitude;
  private int[] sawtooth_amplitude;
  private int[] triangle_amplitude;
  
  private int synthesis_times = 100;//合成回数
  
  SyntheticWave(Wave wave){
    //Waveの各変数を代入
    this.wave = wave;
    
    this.wave_a = wave.get_a();
    this.wave_f = wave.get_f();
    this.wave_signal_length = wave.get_signal_length();
    this.wave_fs = wave.get_fs();
    
    //合成波の生成
    square_amplitude   = new int[this.wave.get_signal_length()];
    sawtooth_amplitude = new int[this.wave.get_signal_length()];
    triangle_amplitude = new int[this.wave.get_signal_length()];
    println(this.square_amplitude.length);
    
    for (int k=0; k<this.wave_signal_length; k++) {
      for (int i=0; i<synthesis_times; i++) {
        this.square_amplitude[k]   += (int)((-this.wave_a/(2*i+1))*sin(2.0*PI*this.wave_f*k*(2*i+1)/this.wave_fs));
        this.sawtooth_amplitude[k] += (int)((-this.wave_a/(i+1))*sin(2.0*PI*this.wave_f*k*(i+1)/this.wave_fs));
        this.triangle_amplitude[k] += (int)pow((-1), i)*((-this.wave_a/sq(2*i+1))*sin(2.0*PI*this.wave_f*k*(2*i+1)/this.wave_fs));
      }
    }
  }


  /*---Getter---*/
  
  public int[] get_square_amplitude(){
    return this.square_amplitude;
  }
  
  public int[] get_sawtooth_amplitude(){
    return this.sawtooth_amplitude;
  }
  
  public int[] get_triangle_amplitude(){
    return this.triangle_amplitude;
  }
}