/**
* 描画する四角形のエリアを定めるクラス
* @author satori
*
*/

class Area {
  private Point left_top;
  private Point right_top;
  private Point left_bottom;
  private Point right_bottom;

  private int top;
  private int right;
  private int bottom;
  private int left;

  private int wid;
  private int hei;

  private boolean isOpen;
  private float swipe_speed=0.4;


  public Area(Point p1, Point p2, Point p3, Point p4) {
    this.left_top = p1;
    this.right_top = p2;
    this.right_bottom = p3;
    this.left_bottom = p4;

    this.top=p1.getY();
    this.right=p2.getX();
    this.bottom=p3.getY();
    this.left=p4.getX();

    this.wid=p2.getX()-p1.getX();
    this.hei=p4.getY()-p1.getY();
  }


  public Point getLeftTop() {
    return this.left_top;
  }

  public Point getRightTop() {
    return this.right_top;
  }

  public Point getLeftBottom() {
    return this.left_bottom;
  }

  public Point getRightBottom() {
    return this.right_bottom;
  }

  public int getTop() {
    return this.top;
  }

  public int getRight() {
    return this.right;
  }

  public int getBottom() {
    return this.bottom;
  }

  public int getLeft() {
    return this.left;
  }

  public int getW() {
    return this.wid;
  }

  public int getH() {
    return this.hei;
  }


  public void setTop(int y) {
    this.left_top.setY(y);
    this.right_top.setY(y);
    this.top=y;
  }

  public void setRight(int x) {
    this.right_top.setX(x);
    this.right_bottom.setX(x);
    this.right=x;
  }

  public void setBottom(int y) {
    this.left_bottom.setY(y);
    this.right_bottom.setY(y);
    this.bottom=y;
  }

  public void setLeft(int x) {
    this.left_top.setX(x);
    this.left_bottom.setX(x);
    this.left=x;
  }

  public void setIsOpen(boolean is_open) {
    this.isOpen=is_open;
  }


  public void Swipe() {
    this.setLeft(
      (int)(this.left + ((
      isOpen
      ? 0
      : -this.wid
      )-this.left)* swipe_speed-0.2));
    this.setRight(this.left+this.wid);

    noStroke();
    fill(#ffffff, 200);
    rect(this.left, this.top, this.wid, height);

    stroke(color(0, 0, 80));
    strokeWeight(2);
    line(this.right, 0, this.right, height);
  }
}