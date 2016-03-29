class MakeTable {
  private int[] sine_table=new int[wave.getDFTSize()];
  private int[] cosine_table=new int[wave.getDFTSize()];

  MakeTable() {
  }


  public int[] get_sine_table() {
    return this.sine_table;
  }

  public int[] get_cosine_table() {
    return this.cosine_table;
  }


  public void calc_sine_table() {
    for (int i=0; i<2048; i++)
      this.sine_table[i]=(int)(32767*(-sin((2.0 * PI * i) / wave.getDFTSize())));
  }

  public void calc_cosine_table() {
    for (int i=0; i<2048; i++)
      this.cosine_table[i] = (int)(32767*cos((2.0 * PI * i) / wave.getDFTSize()));
  }
}