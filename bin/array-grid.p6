#!/usr/bin/env perl6
#
use lib <lib>;

use Grid;



#my @array = <a b c d e f g h i j k l m n o p q r s t u v w x>;
my @array = < 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23>;
@array does Grid[:4columns];

#my @subgrid = 5,2,6,0,3,7,4,1;
#my @subgrid = 1,2,3;

my @subgrid = 9, 10, 13, 14;
#@array := @array.transpose(:@subgrid);
@array := @array.hflip(:@subgrid);

@array.grid;
