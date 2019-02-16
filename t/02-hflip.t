use lib <lib>;

use Test;
use Grid;

my @array = < a b c d e f g h i j k l m n o p q r s t u v w x >;

@array does Grid[:4columns];


my @tests = (
# [Grid Subgrid Result]
[ @array, [0, 4],                 @array ], # @subgrid not valid
[ @array, [3, 4],                 @array ], # @subgrid not valid
[ @array, [1, 7],                 @array ], # @subgrid not valid
[ @array, [0 ... 0],              @array ], # @subgrid not valid
[ @array, [0 ... 4],              @array ], # @subgrid not valid
[ @array, [0 ... 4, 7],           @array ], # @subgrid not valid
[ @array, [0, 4, 8, 12, 16],      @array ], # @subgrid not valid
[ @array, [0, 4, 8, 12, 16, 20],  @array ], # @subgrid not valid
[ @array, [1, 5, 9, 13, 17, 21],  @array ], # @subgrid not valid
[ @array, [3, 7, 11, 15, 19, 23], @array ], # @subgrid not valid

[ @array, [0 ... 1],              < b a c d e f g h i j k l m n o p q r s t u v w x > ],
[ @array, [0 ... 2],              < c b a d e f g h i j k l m n o p q r s t u v w x > ],
[ @array, [0 ... 3],              < d c b a e f g h i j k l m n o p q r s t u v w x > ],
[ @array, [0 ... 7],              < d c b a h g f e i j k l m n o p q r s t u v w x > ],
[ @array, [9 ... 10, 13 ... 14],  < a b c d e f g h i k j l m o n p q r s t u v w x > ],
[ @array, [0 ... 23],             < d c b a h g f e l k j i p o n m t s r q x w v u > ],
);

for @tests -> [ @grid, @subgrid, @result ] {
  ok @result eq @grid.hflip(:@subgrid), "hflip: {@subgrid}";
}

done-testing;
