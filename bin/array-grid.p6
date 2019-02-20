#!/usr/bin/env perl6
#
use lib <lib>;

use Grid;



my @array = <a b c d e f g h i j k l m n o p >;
#my @array = < 0 1 2 3 4 5 6 7 8 >;
@array does Grid[:4columns];

my @indices = 5, 6, 9, 10;

my @column = < 0 1 2 3 >;
my @row = < 0 1 2 3 >;

#my $times = 2;

@array.grid;

#@array.antidiagonal-flip;
say @array.append-row(:@row);
#@array.vertical-flip(:@indices);

say '';
@array.grid;
