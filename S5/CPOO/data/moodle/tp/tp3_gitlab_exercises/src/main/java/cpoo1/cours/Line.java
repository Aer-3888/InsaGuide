package cpoo1.cours;

class Line {
    private Point p1;
    private Point p2;

    public Line(double x1, double y1, double x2, double y2) {
       p1 = new Point(x1, y1);
       p2 = new Point(x2, y2);
    }

    public boolean isVertical() {
        double res = p1.x() - p2.x();
        return Math.abs(res) <= 0.000001;
    }

    public double getA() {
       if(isVertical()) {
          return Double.NaN;
       }
       return (p1.y() - p2.y()) / (p1.x() - p2.x());
    }

    public double getB() {
       return isVertical() ? Double.NaN : p1.y() - getA() * p1.x();
    }
 }

record Point(double x, double y) {
}