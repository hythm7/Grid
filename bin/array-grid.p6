#!/usr/bin/env perl6
#
use lib <lib>;

use Grid;



my @array = <a b c d e f g h i j k l m n o p q r s t u v w x >;
#my @array = < 0 1 2 3 4 5 6 7 8 >;
@array does Grid[:4columns];

my @indices = 1, 2, 5, 6;
#my @indices = 9, 10, 13, 14;
#my @subgrid = 9, 10, 13, 14;

my @column = < 1 2 3 4 5 6 >;
my @row = < 1 2 3 4 >;

my $times = 2;

@array.grid;

@array.diagonal-flip(:@indices);

say '';
@array.grid;
