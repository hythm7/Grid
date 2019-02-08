#!/usr/bin/env perl6
#
use lib <lib>;

use Grid;



my @array = <a b c d e f g h i j k l m n o p q r s t u v w x>;
@array does Grid[:4columns];

#my @subgrid = 5,2,6,0,3,7,4,1;
#my @subgrid = 1,2,3;

my @subgrid = 9, 10, 13, 14;
@array := @array.transpose();

@array.grid;
