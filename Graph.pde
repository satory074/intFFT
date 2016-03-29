class Graph {
  private Axis axis_x;
  private Axis axis_y;
  private Area area;//area of drawing graph

  private int intercept;//y切片


  Graph(Axis x, Axis y, Area a, int b) { 
    this.axis_x=x;
    this.axis_y=y;
    this.area=a;
    this.intercept=b;
  }


  public void setAxis(Axis x, Axis y, Area a, int b) {
    this.axis_x=x;
    this.axis_y=y;
    this.area=a;
    this.intercept=b;
  }


  public void drawGrid() {
    strokeWeight(1);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(12);

    //GridLine
    //vertical
    for (int i=this.area.getLeft(); i<=this.area.getRight(); i+=this.axis_x.getLineInterval()) {
      if ((i-this.area.getLeft())%(this.axis_x.getLineInterval()*5)==0) {
        stroke(220);
      } else {
        //stroke(240);
      }
      text(nf((i-this.area.getLeft())/this.axis_x.getLineInterval()*this.axis_x.getScaleInterval(), 0, 2), i, this.area.getBottom()+10);
      line(i, this.area.getTop(), i, this.area.getBottom());
    }

    //horizontal
    for (int i=this.area.getTop(); i<=this.area.getBottom(); i+=this.axis_y.getLineInterval()) {
      if ((i-this.area.getTop())%(this.axis_y.getLineInterval()*5)==0) {
        stroke(220);
      } else {
        //stroke(240);
      }
      text((int)-((i-this.area.getBottom())/this.axis_y.getLineInterval()*this.axis_y.getScaleInterval()+(this.area.getH()/this.axis_y.getLineInterval())*this.axis_y.getScaleInterval()/2), this.area.getLeft()-20, i);

      line(this.area.getLeft(), i, this.area.getRight(), i);
    }

    //axis-line
    stroke(100);
    line(this.area.getLeft(), this.intercept, this.area.getRight(), this.intercept);

    //Label
    textSize(24);
    text("["+this.axis_x.getLabel()+"]", this.area.getRight()+40, this.area.getBottom()+10);//X
    text("["+this.axis_y.getLabel()+"]", this.area.getLeft()-20, this.area.getTop()-40);//Y
  }

  public void drawWave(int[] r, int[] im) {
    stroke(0, 255, 0);
    strokeWeight(1);
    for (int i =0; i < this.area.getW(); i++)
      line(
        this.area.getLeft()+i, 
        r[i]+this.intercept, 
        this.area.getLeft()+i+1, 
        r[i+1]+this.intercept
        );
  }

  public void drawDFT(int[] a) {
    int max=max(a);
    int min=min(a);

    strokeWeight(1);
    stroke(255, 0, 0);

    for (int i=0; i<this.area.getW(); i++) {
      line(this.area.getLeft()+i, 
        this.area.getBottom(), 
        this.area.getLeft()+i, 
        //map(a[i], min, max, this.area.getBottom(), this.area.getTop())
        a[i]
        );
    }
  }

  public void drawSpectrogram(int[] a) {
    float max=max(a);
    float min=min(a);

    strokeWeight(1);
    bg(0, this.area);

    for (int i=0; i<wave.getSignalLength(); i+=wave.getDFTSize()) {
      for (int j=0; j<this.area.getH(); j++) {

        int c = (int)map(a[j], min, max, 0, 255);
        float y = map(j, 0, a.length, this.area.getBottom(), this.area.getTop());

        if (c>0) {
          stroke(c);
          line(this.area.getLeft()+i, this.area.getBottom()-j, this.area.getLeft()+i+wave.getDFTSize(), this.area.getBottom()-j);
        }
      }
    }

    noStroke();
    fill(220);
    rect(this.area.getRight(), this.area.getTop(), width-this.area.getRight(), height);
  }
}