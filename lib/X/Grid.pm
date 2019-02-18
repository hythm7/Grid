class X::Grid is Exception {

}

class X::Grid::Subgrid is X::Grid {
  has @.subgrid;

  method message { "[{@!subgrid}] is not subgrid." };
}
