use Grid::Util;
use Grid::ErrorHandling;

unit role Grid[:$columns];
  also does Grid::ErrorHandling;

has Int $!columns where * > 0;
has Int $!rows;

submethod BUILD( ) {
  
  $!columns = $columns // (self.elems ?? self.elems !! 1);
  $!rows    = self.elems div $!columns;

  fail "grid" unless self!is-grid;

}

method append-column ( Grid:D: :@column! --> Grid:D ) {

	return self unless @column.elems == $!rows;
  
  self = flat self.rotor($!columns) Z @column;

	$!columns += 1;

	self;

}

method prepend-column ( Grid:D: :@column! --> Grid:D ) {

	return self unless @column.elems == $!rows;
  
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

	return self unless @row.elems == $!columns;

  self = self.append(@row);

	$!rows += 1;

	self;
  
}

method prepend-row ( Grid:D: :@row --> Grid:D ) {

	return self unless @row.elems == $!columns;

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
  
  my @subgrid := self!subgrid(:@indices);

  self[@indices] = self[@subgrid.horizontal-flip];

	self;
  
}

multi method vertical-flip ( Grid:D: --> Grid:D ) {

  self = self.rotor($!columns).reverse.flat;

}

multi method vertical-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid(:@indices);

  self[@indices] = self[@subgrid.vertical-flip];

	self;

}


multi method transpose ( Grid:D: --> Grid:D ) {

   self = flat [Z] self.rotor($!columns);

   ($!columns, $!rows) .= reverse; 

	 self;
}

multi method transpose ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid(:@indices);

	return self unless @subgrid.is-square;

  self[@indices] = self[@subgrid.transpose];

	self;
}

multi method diagonal-flip ( Grid:D: --> Grid:D ) {

  self = self[ diagonal self.keys ];

}

multi method diagonal-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid(:@indices);

  self[@indices] = self[@subgrid.diagonal-flip];

	self;
}

multi method antidiagonal-flip ( Grid:D: --> Grid:D ) {

  self = self[ antidiagonal self.keys ];

}

multi method antidiagonal-flip ( Grid:D: :@indices! --> Grid:D ) {
  
  my @subgrid := self!subgrid(:@indices);

  self[@indices] = self[@subgrid.antidiagonal-flip];

	self;
}

multi method clockwise-rotate ( Grid:D: --> Grid:D ) {
  
	self.transpose.horizontal-flip;
}

multi method clockwise-rotate ( Grid:D: :@indices! ) {

  my @subgrid := self!subgrid(:@indices);

	return self unless @subgrid.is-square;

  self[@indices] = self[@subgrid.clockwise-rotate];

	self;

}

multi method anticlockwise-rotate ( Grid:D: --> Grid:D ) {

  self.transpose.vertical-flip;
}

multi method anticlockwise-rotate ( Grid:D: :@indices! --> Grid:D ) {

my @subgrid := self!subgrid(:@indices);

	return self unless @subgrid.is-square;

  self[@indices] = self[@subgrid.anticlockwise-rotate];

	self;

}

method grid () {
  # TODO: indentation
  .put for self.rotor($!columns);
}




submethod !subgrid( :@indices! --> Grid:D ) {
  CATCH {
    my @subgrid;
    say "warn::subgrid:: {@subgrid.VAR.name} is not subgrid." when 'rows';
    say "warn::subgrid:: {@subgrid.VAR.name} is not subgrid." when 'grid';

		@subgrid does Grid;

		@subgrid;

  }
  
  @indices .= sort.unique;
  
	#my $columns = (@subgrid Xmod $!columns).unique.elems;
  my $columns =  @indices.rotor(2 => -1, :partial).first( -> @a {
    (@a.head.succ != @a.tail) or (not @a.tail mod $!columns)
  }):k + 1;
  
  
  
  self!check-subgrid(:@indices, :$columns);
  
	my @subgrid = @indices;
  @subgrid does Grid[:$columns];
  @subgrid;
}

submethod !is-grid ( Grid:D: --> Bool:D ) {
  self.elems == $!columns * $!rows;
}

submethod is-square ( --> Bool:D ) {
  #return False if $!columns < 2;
  $!columns == $!rows;
}

submethod !check-subgrid (:@indices!, :$columns --> True) {
  # fail  unless [eqv] (@subgrid Xmod $!columns).rotor(@subgrid.columns, :partial);
  fail 'rows' unless @indices.rotor($columns).rotor(2 => -1).map( ->@a {
      (@a.head X+ $!columns) eq @a.tail;
  }).all.so ;
  
}

