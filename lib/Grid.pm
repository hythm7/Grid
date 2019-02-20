use Grid::Util;

unit role Grid[:$columns];
  
has Int $!columns;
has Int $!rows;

submethod BUILD( ) is hidden-from-backtrace {
  #say $columns;
  $!columns = $columns // self.elems;
  
  die "Can't have grid of {$!columns} columns" unless $!columns;
  
  $!rows    = self.elems div $!columns;
  
  die "Can't have grid of {self.elems} elements with {$!columns} columns"
    unless self.elems == $!columns * $!rows;
}

method append-column ( Grid:D: :@column! --> Grid:D ) {

  return self unless self.check-column( :@column );
  
  self = flat self.rotor($!columns) Z @column;

  $!columns += 1;

  self;

}

method prepend-column ( Grid:D: :@column! --> Grid:D ) {

  return self unless self.check-column( :@column );
  
  self = flat @column Z self.rotor($!columns);

  $!columns += 1;

  self;
}

method pop-columns ( Grid:D:  Int :$columns = 1 --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).head($!columns - $columns);

  $!columns -= $columns;

  self;
  
}

method shift-columns ( Grid:D:  Int :$columns = 1 --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).tail($!columns - $columns);
  
  $!columns -= $columns;

  self;

}

method rotate-columns-left ( Grid:D:  Int :$times = 1 --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).list.rotate($times);
  
}

method rotate-columns-right ( Grid:D:  Int :$times = 1 --> Grid:D ) {

  self = flat [Z] ([Z] self.rotor($!columns)).list.rotate(- $times);
  
}


method append-row ( Grid:D: :@row --> Grid:D ) {

  return self unless self.check-row( :@row );

  self = self.append(@row);

  $!rows += 1;

  self;
  
}

method prepend-row ( Grid:D: :@row --> Grid:D ) {

  return self unless self.check-row( :@row );

  self = self.prepend(@row);
  
  $!rows += 1;

  self;
}

method pop-rows ( Grid:D:  Int :$rows = 1 --> Grid:D ) {

  self = flat self.rotor($!columns).head($!rows - $rows);

  $!rows -= $rows;

  self;

}

method shift-rows ( Grid:D:  Int :$rows = 1 --> Grid:D ) {

  self = flat self.rotor($!columns).tail($!rows - $rows);
  
  $!rows -= $rows;

  self;

}

method rotate-rows-up ( Grid:D:  Int :$times = 1 --> Grid:D ) {

  self = flat self.rotor($!columns).list.rotate($times);
  
}

method rotate-rows-down ( Grid:D:  Int :$times = 1 --> Grid:D ) {

  self = flat self.rotor($!columns).list.rotate(- $times);
  
}



multi method horizontal-flip ( Grid:D: --> Grid:D ) {

  self = self.rotor($!columns).map(*.reverse).flat;

}

multi method horizontal-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid( :@indices );

  return self unless @subgrid;

  
  self[@indices] = self[@subgrid.horizontal-flip];

  return self;
  
 
}

multi method vertical-flip ( Grid:D: --> Grid:D ) {

  self = self.rotor($!columns).reverse.flat;

}

multi method vertical-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid( :@indices );

  return self unless @subgrid;

  self[@indices] = self[@subgrid.vertical-flip];

  self;

}


multi method transpose ( Grid:D: --> Grid:D ) {

   self = flat [Z] self.rotor($!columns);

   ($!columns, $!rows) .= reverse; 

   self;
}

multi method transpose ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid( :@indices, :square );

  return self unless @subgrid;

  self[@indices] = self[@subgrid.transpose];

  self;
}

multi method diagonal-flip ( Grid:D: --> Grid:D ) {

  return self unless self.is-square;

  self = self[ diagonal self.keys ];

}

multi method diagonal-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid( :@indices, :square );

  return self unless @subgrid;

  self[@indices] = self[@subgrid.diagonal-flip];

  self;
}

multi method antidiagonal-flip ( Grid:D: --> Grid:D ) {

  return self unless self.is-square;

  self = self[ antidiagonal self.keys ];

}

multi method antidiagonal-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid( :@indices, :square );

  return self unless @subgrid;

  self[@indices] = self[@subgrid.antidiagonal-flip];

  self;
}

multi method clockwise-rotate ( Grid:D: --> Grid:D ) {
  
  self.transpose.horizontal-flip;
}

multi method clockwise-rotate ( Grid:D: :@indices! ) {

  my @subgrid := self!subgrid( :@indices, :square );

  return self unless @subgrid;

  self[@indices] = self[@subgrid.clockwise-rotate];

  self;

}

multi method anticlockwise-rotate ( Grid:D: --> Grid:D ) {

  self.transpose.vertical-flip;
}

multi method anticlockwise-rotate ( Grid:D: :@indices! --> Grid:D ) {

my @subgrid := self!subgrid( :@indices, :square );

  return self unless @subgrid;

  self[@indices] = self[@subgrid.anticlockwise-rotate];

  self;

}

method grid () {
  # TODO: indentation
  .put for self.rotor($!columns);
}




submethod !subgrid( :@indices!, :$square = False ) {
  @indices .= sort.unique;
    

  die "[{@indices}] is not subgrid of {self.VAR.name}"
    if @indices.tail > self.end;
  
  #my $columns = (@subgrid Xmod $!columns).unique.elems;
  my $columns =  @indices.rotor(2 => -1, :partial).first( -> @a {
    (@a.head.succ != @a.tail) or (not @a.tail mod $!columns)
  }):k + 1;

#Verify rows
# fail  unless [eqv] (@subgrid Xmod $!columns).rotor(@subgrid.columns, :partial);
  die "[{@indices}] is not subgrid of {self.VAR.name}"
    unless @indices.rotor($columns).rotor(2 => -1).map( -> @a {
      (@a.head X+ $!columns) eq @a.tail;
    }).all.so ;

# if $columns == 1 {
 #verify columns
#   die "[{@indices}] is not subgrid of {self.VAR.name}"
#    unless @indices.rotor($columns).rotor(2 => -1).map( -> @a {
#      ( @a.tail.head - @a.head.tail ) < $!columns;
#    }).all.so ;
#}
 
  my @subgrid = @indices;
  @subgrid does Grid[:$columns];

  $square and die "[{@indices}] is not square subgrid of {self.VAR.name}" unless @subgrid.is-square;

  return @subgrid;

  CATCH {
    note .message;
    return Array;
  }
}

submethod has-subgrid( :@indices!, :$square = False --> Bool:D ) {

  my @subgrid := self!subgrid( :@indices, :$square );
  
  return True if @subgrid ~~ Grid;

  False;

}

submethod is-square ( --> Bool:D ) {
  #return False if $!columns < 2;
  $!columns == $!rows;
}

submethod check-column ( :@column --> Bool:D ) {
  return True if @column.elems == $!rows;
  note "Column check failed, must have {$!rows} elements.";
  False;
}

submethod check-row ( :@row --> Bool:D ) {
  return True if @row.elems == $!columns;
  note "Row check failed, must have {$!columns} elements.";
  False;
}
