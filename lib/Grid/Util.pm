unit role Grid::Util;

submethod !check-grid () {
  fail unless self.columns > 0;
}
