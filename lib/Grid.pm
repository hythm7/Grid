use Grid::Util;

unit role Grid[:$columns!];
  also does Grid::Util;

has Int $!columns = $columns;
has Int $!rows    = self.elems div $!columns;

method columns () { $!columns }
method rows () { $!rows }

multi method hflip (Grid:D:) {

  my @grid = self.rotor($!columns).map(*.reverse).flat;
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method hflip (Grid:D: :@subgrid!) {
  my @indices := self!subgrid(:@subgrid);
	return self unless @indices;
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.hflip];
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method vflip (Grid:D:) {
  my @grid = self.rotor($!columns).reverse.flat;
  
  @grid does Grid[:$!columns];
  @grid;
}

multi method vflip (Grid:D: :@subgrid!) {
  
  my @indices := self!subgrid(:@subgrid);
	return self unless @indices;
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.vflip];
  
  @grid does Grid[:$!columns];
  @grid;
}


multi method transpose (Grid:D:) {
  my @transposed;
  my @rotored = self.rotor($!columns);

  for ^$!rows X ^$!columns -> ($r, $c) {
    @transposed[$c][$r] = @rotored[$r][$c];
  }

   my @grid = gather @transposed.deepmap: *.take;
   
   @grid does Grid[columns => $!rows];
	 @grid;
}

multi method transpose (Grid:D: :@subgrid!) {
  
  my @indices := self!subgrid(:@subgrid);
  
	return self unless @indices;
  return self unless @indices.is-square;
  
  my @grid = self;
  @grid[@indices] = @grid[@indices.transpose];
  
  @grid does Grid[:$!columns];
	@grid;
}


multi method crotate (Grid:D:) {
  self.transpose.hflip;
}

multi method crotate (Grid:D: :@subgrid!) {
  my @indices := self!subgrid(:@subgrid);
  return self unless @indices;
  return self unless @indices.is-square;
  self.transpose(subgrid => @indices).hflip(subgrid => @indices);
}

multi method arotate (Grid:D:) {
  self.transpose.vflip;
}

multi method arotate (Grid:D: :@subgrid!) {
  my @indices := self!subgrid(:@subgrid);
  return self unless @indices;
  return self unless @indices.is-square;
  self.transpose(subgrid => @indices).vflip(subgrid => @indices);
}


# TODO: grid indentation;
method grid () {
  .put for self.rotor($!columns);
}

method !subgrid(:@subgrid! is copy) {
  @subgrid .= sort.unique;
	my $columns =  self!subgrid-columns(:@subgrid);
	return Array if @subgrid.elems mod $columns;
  # maybe [-] @subgrid eq $!columns?
	return Array unless @subgrid.rotor($columns).rotor(2 => -1).map( ->@a {
    (@a.head X+ $!columns) eq @a.tail;
    }).all.so ;
    
  @subgrid does Grid[:$columns];
  @subgrid;
}

method !subgrid-columns(:@subgrid --> Int) {
	my $columns =  @subgrid.rotor(2 => -1, :partial).first( -> @a { (@a.head.succ != @a.tail) or (not @a.tail mod self.columns)  }):k + 1;
  $columns = $!columns if self.elems == $columns;
  
  $columns;
}

method is-square (--> Bool) {
  #return False if $!columns < 2;
  $!columns == $!rows;
}

sub get-subgrid-columns (:@subgrid) {

}

=begin pod

=head1 NAME

Grid - blah blah blah

=head1 SYNOPSIS

=begin code :lang<perl6>

use Grid;

=end code

=head1 DESCRIPTION

Grid is ...

=head1 AUTHOR

Haythem Elganiny <haythem.elganiny@moorecap.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 Haythem Elganiny

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
