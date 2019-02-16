unit role Grid[:$columns];

has Int $!columns where * > 0;
has Int $!rows;

submethod BUILD( ) {
  
  $!columns = $columns // (self.elems ?? self.elems !! 1);
  $!rows    = self.elems div $!columns;

  fail "grid" unless self!is-grid;

}

method append-column ( Grid:D: @column --> Grid:D ) {
  
}

method append-row ( Grid:D: @row --> Grid:D ) {
  
}

multi method hflip ( Grid:D: --> Grid:D ) {

  my @grid = self.rotor($!columns).map(*.reverse).flat;
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method hflip ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.hflip];
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method vflip ( Grid:D: --> Grid:D ) {
  my @grid = self.rotor($!columns).reverse.flat;
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method vflip ( Grid:D: :@subgrid! --> Grid:D ) {
  
  my @indices := self!subgrid(:@subgrid);
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.vflip];
  
  @grid does Grid[:$!columns];
  @grid;
}


multi method transpose ( Grid:D: --> Grid:D ) {
  my @transposed;
  my @rotored = self.rotor($!columns);

  for ^$!rows X ^$!columns -> ($r, $c) {
    @transposed[$c][$r] = @rotored[$r][$c];
  }

   my @grid = gather @transposed.deepmap: *.take;
   
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


multi method crotate ( Grid:D: --> Grid:D ) {
  self.transpose.hflip;
}

multi method crotate ( Grid:D: :@subgrid! ) {
  my @indices := self!subgrid(:@subgrid);
  return self unless @indices.is-square;
  self.transpose(subgrid => @indices).hflip(subgrid => @indices);
}

multi method arotate ( Grid:D: --> Grid:D ) {
  self.transpose.vflip;
}

multi method arotate ( Grid:D: :@subgrid! --> Grid:D ) {
  my @indices := self!subgrid(:@subgrid);
  return self unless @indices.is-square;
  self.transpose(subgrid => @indices).vflip(subgrid => @indices);
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



