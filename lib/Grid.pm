unit role Grid[ Int :$columns ];

has Int $!columns;
has Int $!rows;

submethod BUILD is hidden-from-backtrace {

  $!columns = $columns // self.elems;

  die "Can't have grid of {$!columns} columns" unless $!columns;

  $!rows    = self.elems div $!columns;

  die "Can't have grid of {self.elems} elements with {$!columns} columns"
    unless self.elems == $!columns * $!rows;

}

method columns {
  $!columns;
}

method rows {
  $!rows;
}

method reshape ( Grid:D:  Int :$columns! where * > 0 --> Grid:D ) {

  my $rows = self.elems div $columns;

  return self unless self.elems == $columns * $rows;

  $!rows    = $rows;
  $!columns = $columns;

  self;

}

multi method flip ( Grid:D: Int:D :$horizontal! --> Grid:D ) {

  self = self.rotor( $!columns ).map( *.reverse ).flat;

}

multi method flip ( Grid:D: Int:D :$vertical! --> Grid:D ) {

  self = self.rotor( $!columns ).reverse.flat;

}

multi method flip ( Grid:D: Int:D :$diagonal! --> Grid:D ) {

  return self unless self.is-square;

  self = self[ diagonal self.keys ];

}

multi method flip ( Grid:D: Int:D :$antidiagonal! --> Grid:D ) {

  return self unless self.is-square;

  self = self[ antidiagonal self.keys ];

}

multi method flip ( Grid:D: :@horizontal! --> Grid:D ) {

  my @subgrid := self!subgrid( @horizontal );

  return self unless @subgrid;

  self[ @horizontal ] = self[ @subgrid.flip: :horizontal ];

  return self;

}

multi method flip ( Grid:D: :@vertical! --> Grid:D ) {

  my @subgrid := self!subgrid( @vertical );

  return self unless @subgrid;

  self[ @vertical ] = self[ @subgrid.flip: :vertical ];

  self;

}

multi method flip ( Grid:D: :@diagonal! --> Grid:D ) {

  my @subgrid := self!subgrid( @diagonal, :square );

  return self unless @subgrid;

  self[ @diagonal ] = self[ @subgrid.flip: :diagonal ];

  self;

}

multi method flip ( Grid:D: :@antidiagonal! --> Grid:D ) {

  my @subgrid := self!subgrid( @antidiagonal, :square );

  return self unless @subgrid;

  self[ @antidiagonal ] = self[ @subgrid.flip: :antidiagonal ];

  self;

}


multi method rotate ( Grid:D:  Int:D :$left! --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).list.rotate($left);

}

multi method rotate ( Grid:D:  Int:D :$right! --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).list.rotate(- $right);

}

multi method rotate ( Grid:D:  Int:D :$up! --> Grid:D ) {

  self = flat self.rotor($!columns).list.rotate($up);

}

multi method rotate ( Grid:D:  Int:D :$down! --> Grid:D ) {

  self = flat self.rotor($!columns).list.rotate(- $down);

}

multi method rotate ( Grid:D: Int:D :$clockwise! --> Grid:D ) {

  self.transpose.flip :horizontal;

}

multi method rotate ( Grid:D: Int:D :$anticlockwise! --> Grid:D ) {

  self.transpose.flip :vertical;

}

multi method rotate ( Grid:D: :@clockwise! --> Grid:D ) {

  my @subgrid := self!subgrid( @clockwise, :square );

  return self unless @subgrid;

  self[ @clockwise ] = self[ @subgrid.rotate: :clockwise ];

  self;

}

multi method rotate ( Grid:D: :@anticlockwise! --> Grid:D ) {

my @subgrid := self!subgrid( @anticlockwise, :square );

  return self unless @subgrid;

  self[ @anticlockwise ] = self[ @subgrid.rotate: :anticlockwise ];

  self;

}


multi method transpose ( Grid:D: --> Grid:D ) {

   self = flat [Z] self.rotor( $!columns );

   ($!columns, $!rows) .= reverse;

   self;

}

multi method transpose ( Grid:D: :@index! --> Grid:D ) {

  my @subgrid := self!subgrid( @index, :square );

  return self unless @subgrid;

  self[ @index ] = self[ @subgrid.transpose ];

  self;

}

proto method append ( Grid:D: | --> Grid:D ) { * }

multi method append ( Grid:D: :@rows! --> Grid:D ) {

  return self unless self.check( :@rows );

  self = flat self, @rows;

  $!rows += +@rows div $!columns;

  self;

}

multi method append ( Grid:D: :@columns! --> Grid:D ) {

  return self unless self.check( :@columns );

  self = flat self.rotor($!columns) Z @columns;

  $!columns += +@columns div $!rows;

  self;

}


proto method push ( Grid:D: | --> Grid:D ) { * }

multi method push ( Grid:D: :@rows! --> Grid:D ) {

  return self unless self.check( :@rows );

  self = flat self, @rows;

  $!rows += +@rows div $!columns;

  self;

}

multi method push ( Grid:D: :@columns! --> Grid:D ) {

  return self unless self.check( :@columns );

  self = flat self.rotor($!columns) Z @columns;

  $!columns += +@columns div $!rows;

  self;

}


proto method prepend ( Grid:D: | --> Grid:D ) { * }

multi method prepend ( Grid:D: :@rows! --> Grid:D ) {

  return self unless self.check( :@rows );

  self = flat @rows, self;

  $!rows += +@rows div $!columns;

  self;

}

multi method prepend ( Grid:D: :@columns! --> Grid:D ) {

  return self unless self.check( :@columns );

  self = flat @columns Z self.rotor($!columns);

  $!columns += +@columns div $!rows;

  self;

}

proto method unshift ( Grid:D: | --> Grid:D ) { * }

multi method unshift ( Grid:D: :@rows! --> Grid:D ) {

  return self unless self.check( :@rows );

  self = flat @rows, self;

  $!rows += +@rows div $!columns;

  self;

}

multi method unshift ( Grid:D: :@columns! --> Grid:D ) {

  return self unless self.check( :@columns );

  self = flat @columns Z self.rotor($!columns);

  $!columns += +@columns div $!rows;

  self;

}


proto method pop ( Grid:D: | --> Grid:D ) { * }

multi method pop ( Grid:D:  Int :$rows! --> Grid:D ) {

  self = flat self.rotor($!columns).head($!rows - $rows);

  $!rows -= $rows;

  self;

}

multi method pop ( Grid:D:  Int :$columns! --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).head($!columns - $columns);

  $!columns -= $columns;

  self;

}


proto method shift ( Grid:D: | --> Grid:D ) { * }

multi method shift ( Grid:D:  Int :$rows! --> Grid:D ) {

  self = flat self.rotor($!columns).tail($!rows - $rows);

  $!rows -= $rows;

  self;

}

multi method shift ( Grid:D:  Int :$columns! --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).tail($!columns - $columns);

  $!columns -= $columns;

  self;

}


proto method splice ( Grid:D: :$rows, :$columns --> Grid:D ) { * }


method grid ( Grid:D: Bool:D :$formatted = False ) {

  $formatted
    ?? self.rotor($!columns).map( *.join ).join: "\n"
    !! self.rotor($!columns).map( *.join );

}


method has-subgrid( :@index!, :$square = False --> Int:D ) {

  my @subgrid := self!subgrid( @index, :$square );

  return @subgrid.columns if @subgrid ~~ Grid;

  False;

}

method is-square ( --> Bool:D ) {

  $!columns == $!rows;

}

multi method check ( :@columns! --> Bool:D ) {

  return True unless @columns.elems mod $!rows;

  False;

}

multi method check ( :@rows! --> Bool:D ) {

  return True unless @rows.elems mod $!columns;

  False;

}

submethod !subgrid( @index, :$square = False ) {

  @index .= sort .= unique;

  die "[{@index}] is not subgrid of {self.VAR.name}"
    if @index.tail > self.end;

  #my $columns = (@subgrid Xmod $!columns).unique.elems;
  my $columns =  @index.rotor(2 => -1, :partial).first( -> @a {
    (@a.head.succ != @a.tail) or (not @a.tail mod $!columns)
  }):k + 1;

  # fail  unless [eqv] (@subgrid Xmod $!columns).rotor(@subgrid.columns, :partial);
  die "[{@index}] is not subgrid of {self.VAR.name}"
    unless @index.rotor($columns).rotor(2 => -1).map( -> @a {
      (@a.head X+ $!columns) eq @a.tail;
    }).all.so ;


  my @subgrid = @index;

  @subgrid does Grid[:$columns];

  $square and die "[{@index}] is not square subgrid of {self.VAR.name}" unless @subgrid.is-square;

  return @subgrid;


  CATCH { return Array }

}


sub diagonal ( @perfect --> Array ) {
  #TODO: check if not perfect square

  my $root = @perfect.sqrt.Int;

  sub diagonaled-index ( Int $index ) {
    return $index when $index == @perfect.end;
    return $index * $root mod @perfect.end;
  }

  my @diagonaled = @perfect[ @perfect.keys.map: *.&diagonaled-index ];

  @diagonaled;

}


sub antidiagonal ( @perfect --> Array) {
  my $root = @perfect.sqrt.Int;

  multi antidiagonal-index ( Int $index ) {
    my $newindex = @perfect.end - $index * $root;

    return $newindex unless $newindex < 0;
    samewith $newindex;
  }

  multi antidiagonal-index (Int $index where * < 0) {
    my $newindex = $index + @perfect.end;
    return $newindex unless $newindex < 0;
    samewith $newindex;
  }


  my @antidiagonaled = @perfect[ @perfect.keys.map: *.&antidiagonal-index ];

  @antidiagonaled;

}

