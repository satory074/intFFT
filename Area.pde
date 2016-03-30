/**
* 描画する四角形のエリアを定めるクラス
* @author satori
*
*/

class Area{
  private int x;
  private int y;
  private int wid;
  private int hei;


  public Area(int x, int y, int wid, int hei) {
    this.x = x;
    this.y = y;
    this.wid = wid;
    this.hei = hei;
  }
  

  public int get_width() {
    return this.wid;
  }

  public int get_height() {
    return this.hei;
  }
  
  
  public void bg(color c) {
    noStroke();
    fill(c);
    rect(this.x, this.y, this.wid, this.hei);
  }
}