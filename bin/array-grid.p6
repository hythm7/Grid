#!/usr/bin/env perl6
#
use lib <lib>;

use Grid;



my @array = < a b c d e f g h i j k l m n o p q r s t u v w x >;
#my @array = < 0 1 2 3 4 5 6 7 8 >;
@array does Grid[:4columns];

my @anticlockwise = 9, 10, 13, 14;
my @indices = 9, 10, 13, 14;

my @columns = < 0 1 2 3 4 5 >;
my @rows = < 0 1 2 3 >;

#my @antidiagonal = 4 ... 19;
@array.append: :@columns;
@array.grid;
