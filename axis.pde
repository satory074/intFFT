class Axis {
  private float line_interval;//interval of thin line
  private float scale_interval;
  private String label;

  Axis(float li, float si, String la) {
    this.line_interval=li;
    this.scale_interval=si;
    this.label=la;
  }

  public float getLineInterval() {
    return this.line_interval;
  }

  public float getScaleInterval() {
    return this.scale_interval;
  }

  public String getLabel() {
    return this.label;
  }
}