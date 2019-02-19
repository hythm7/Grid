unit package X::Grid;

class Grid::Elements is Exception {
  has Str $.type    = 'Err';
  has     @.who;
  
  method message { "{$!type}: {@!who} is not valid Grid with provided columns. Abort." };

}


class Subgrid::Cells is Exception {
  has Str $.type    = 'Warn';
  has     @.grid;
  has     @.who;
  
  method message { "{$!type}: [{@!who}] is not a subgrid of {@!grid}. Returning." };
  
}
