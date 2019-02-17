unit role Grid[:$columns];

has Int $!columns where * > 0;
has Int $!rows;

submethod BUILD( ) {
  
  $!columns = $columns // (self.elems ?? self.elems !! 1);
  $!rows    = self.elems div $!columns;

  fail "grid" unless self!is-grid;

}

method append-column ( Grid:D: :@column! --> Grid:D ) {
	return self unless @column.elems == $!rows;
  
  my @grid = flat self.rotor($!columns) Z @column;

  @grid does Grid[ :columns($!columns + 1) ];
  @grid;
}

method prepend-column ( Grid:D: :@column! --> Grid:D ) {
	return self unless @column.elems == $!rows;
  
  my @grid = flat @column Z self.rotor($!columns);

  @grid does Grid[ :columns($!columns + 1) ];
  @grid;
}

method pop-columns ( Grid:D:  Int :$columns = 1 --> Grid:D ) {

	my @grid = flat [Z] ([Z] self.rotor($!columns)).head($!columns - $columns);

  
  @grid does Grid[ :columns($!columns - $columns) ];
  @grid;
}

method shift-columns ( Grid:D:  Int :$columns = 1 --> Grid:D ) {

	my @grid = flat [Z] ([Z] self.rotor($!columns)).tail($!columns - $columns);
  
  @grid does Grid[ :columns($!columns - $columns) ];
  @grid;
}

method rotate-columns-left ( Grid:D:  Int :$columns = 1 --> Grid:D ) {

  my @grid = flat [Z] ([Z] self.rotor($!columns)).list.rotate($columns);
  
  @grid does Grid[:$!columns];
  @grid;
}

method rotate-columns-right ( Grid:D:  Int :$columns = 1 --> Grid:D ) {

  my @grid = flat [Z] ([Z] self.rotor($!columns)).list.rotate(- $columns);
  
  @grid does Grid[:$!columns];
  @grid;
}


method append-row ( Grid:D: :@row --> Grid:D ) {

	return self unless @row.elems == $!columns;

  my @grid = self.append(@row);
  
  @grid does Grid[:$!columns];
  @grid;
}

method prepend-row ( Grid:D: :@row --> Grid:D ) {

	return self unless @row.elems == $!columns;

  my @grid = self.prepend(@row);
  
  @grid does Grid[:$!columns];
  @grid;
}

method pop-rows ( Grid:D:  Int :$rows = 1 --> Grid:D ) {

  my @grid = flat self.rotor($!columns).head($!rows - $rows);

  
  @grid does Grid[:$!columns];
  @grid;
}

method shift-rows ( Grid:D:  Int :$rows = 1 --> Grid:D ) {

  my @grid = flat self.rotor($!columns).tail($!rows - $rows);
  
  @grid does Grid[:$!columns];
  @grid;
}

method rotate-rows-up ( Grid:D:  Int :$rows = 1 --> Grid:D ) {

  my @grid = flat self.rotor($!columns).list.rotate($rows);
  
  @grid does Grid[:$!columns];
  @grid;
}

method rotate-rows-down ( Grid:D:  Int :$rows = 1 --> Grid:D ) {

  my @grid = flat self.rotor($!columns).list.rotate(- $rows);
  
  @grid does Grid[:$!columns];
  @grid;
}



multi method horizontal-flip ( Grid:D: --> Grid:D ) {

  my @grid = self.rotor($!columns).map(*.reverse).flat;
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method horizontal-flip ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.horizontal-flip];
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method vertical-flip ( Grid:D: --> Grid:D ) {
  my @grid = self.rotor($!columns).reverse.flat;
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method vertical-flip ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.vertical-flip];
  
  @grid does Grid[:$!columns];
  @grid;
}


multi method transpose ( Grid:D: --> Grid:D ) {

   my @grid = flat [Z] self.rotor($!columns);
   
   @grid does Grid[columns => $!rows];
	 @grid;
}

multi method transpose ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  return self unless @indices.is-square;
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.transpose];
  
  @grid does Grid[:$!columns];
	@grid;
}

multi method diagonal-flip ( Grid:D: --> Grid:D ) {

  my @grid = self[ diagonal self.keys ];
  @grid does Grid[:$!columns];
   
	@grid;
}

multi method diagonal-flip ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  return self unless @indices.is-square;
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.diagonal-flip];
  
  @grid does Grid[:$!columns];
	@grid;
}

multi method antidiagonal-flip ( Grid:D: --> Grid:D ) {

  my @grid = self[ antidiagonal self.keys ];
  @grid does Grid[:$!columns];
   
	@grid;
}

multi method antidiagonal-flip ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  return self unless @indices.is-square;
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.antidiagonal-flip];
  
  @grid does Grid[:$!columns];
	@grid;
}




multi method clockwise-rotate ( Grid:D: --> Grid:D ) {
  self.transpose.horizontal-flip;
}

multi method clockwise-rotate ( Grid:D: :@subgrid! ) {
  my @indices := self!subgrid(:@subgrid);
  return self unless @indices.is-square;
  self.transpose(subgrid => @indices).horizontal-flip(subgrid => @indices);
}

multi method anticlockwise-rotate ( Grid:D: --> Grid:D ) {
  self.transpose.vertical-flip;
}

multi method anticlockwise-rotate ( Grid:D: :@subgrid! --> Grid:D ) {
  my @indices := self!subgrid(:@subgrid);
  return self unless @indices.is-square;
  self.transpose(subgrid => @indices).vertical-flip(subgrid => @indices);
}

method grid () {
  # TODO: indentation
  .put for self.rotor($!columns);
}




submethod !subgrid( :@subgrid! is copy ) {
  CATCH {
    my @subgrid;
    say "warn::subgrid:: {@subgrid.VAR.name} is not subgrid." when 'rows';
    say "warn::subgrid:: {@subgrid.VAR.name} is not subgrid." when 'grid';
    return @subgrid does Grid;
  }
  
  @subgrid .= sort.unique;
  
	#my $columns = (@subgrid Xmod $!columns).unique.elems;
  my $columns =  @subgrid.rotor(2 => -1, :partial).first( -> @a {
    (@a.head.succ != @a.tail) or (not @a.tail mod $!columns)
  }):k + 1;
  
  
  
  self!check-subgrid(:@subgrid, :$columns);
  
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

submethod !check-subgrid (:@subgrid!, :$columns --> True) {
  # fail  unless [eqv] (@subgrid Xmod $!columns).rotor(@subgrid.columns, :partial);
  fail 'rows' unless @subgrid.rotor($columns).rotor(2 => -1).map( ->@a {
      (@a.head X+ $!columns) eq @a.tail;
  }).all.so ;
  
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
