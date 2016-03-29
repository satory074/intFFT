import controlP5.*;
ControlP5 cp5;

//レイアウト
int MARGIN=80;       //余白
int GRAPH_HEIGHT=480;//グラフエリアの高さ
int GRAPH_WIDTH=720; //グラフエリアの幅

//波
//                  A              f    fs     信号長
Wave wave=new Wave((int)pow(2,15), 100, 44100, 88200);

//グラフ
Area graph_area=new Area(
  new Point(MARGIN,             MARGIN),              //左上
  new Point(MARGIN+GRAPH_WIDTH, MARGIN),              //右上 
  new Point(MARGIN+GRAPH_WIDTH, MARGIN+GRAPH_HEIGHT), //右下 
  new Point(MARGIN,             MARGIN+GRAPH_HEIGHT));//左下
  
Graph graph=new Graph(
  new Axis(1000,              0.1,  "s"),//X軸
  new Axis(graph_area.getH(), 20.0, "" ),//Y軸
  graph_area,                            //範囲
  GRAPH_HEIGHT/2+MARGIN);                //切片

//タブ
Area tab_area=new Area(
  new Point(-150, 0),                     //左上
  new Point(0,    0),                     //右上
  new Point(0,    GRAPH_HEIGHT+MARGIN*2), //右下
  new Point(-150, GRAPH_HEIGHT+MARGIN*2));//左下

TabButton graph_button=new TabButton(
  tab_area,                                        //エリア 
  new String[] {"Wave", "Spectrum", "Spectrogram"},//名前の配列
  color(0, 0, 255),                                //色
  1);                                              //タブの始点
    
TabButton wave_button=new TabButton(
  tab_area,                                               //エリア 
  new String[] {"sine", "square", "sawtooth", "triangle"},//名前の配列
  color(0, 255, 0),                                       //色
  120);                                                   //タブの始点
  
  
MakeTable mt=new MakeTable();
boolean isFT=false;

void settings() {
  size(GRAPH_WIDTH+MARGIN, GRAPH_HEIGHT+MARGIN*2);
}

void setup() {
  cp5=new ControlP5(this);
  
  wave.generateWave();
  wave_button.generate();
  graph_button.generate();
  
  mt.calc_sine_table();
  mt.calc_cosine_table();
  
  //int[] arry=wave.getSineReal();
  //for(int i=0;i<1000;i++)
  //println(arry[i]);
}

void draw() {
  background(220);

  bg(255, graph_area);
  surface.setTitle(graph_button.get_element_name(graph_button.get_selected_id())+"｜"+wave_button.get_element_name(wave_button.get_selected_id()));

  switch(graph_button.get_element_name(graph_button.get_selected_id())) {
  case "Wave":
    graph.drawGrid();
    graph.drawWave(wave.getVisibleReal(), wave.getImag());
    break;

  case "Spectrum":
    graph.drawDFT(wave.getAmplitude());
    break;

  case "Spectrogram":
    graph.drawSpectrogram(wave.getAmplitude());
    break;
  }


  graph_button.update();
  wave_button.update();

  //swipe tab
  tab_area.Swipe();
  tab_area.setIsOpen(mouseX<tab_area.getW() 
    ? true
    : false);

  if (isFT) {
    dftThread dft=new dftThread();
    Thread dftThread=new Thread(dft);
    dftThread.start();

    isFT=false;
  }

  wave.setVisibleWave(wave_button.get_element_name(wave_button.get_selected_id()));
}

public class dftThread implements Runnable {
  public void run() {
    wave.doFFT(wave.getVisibleReal(), wave.getImag(), wave.getDFTSize());
  }
}

void bg(color c, Area a) {
  noStroke();
  fill(c);
  rect(a.getLeft(), a.getTop(), a.getW(), a.getH());
}

public void controlEvent(ControlEvent theEvent) {
  int id=theEvent.getController().getId();
  if (id <= graph_button.get_start_Y()+graph_button.get_element_count()) graph_button.set_selected_id(id);
  else wave_button.set_selected_id(id);
}

void mouseClicked() {
  isFT=true;
}