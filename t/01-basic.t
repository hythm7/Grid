use lib <lib>;

use Test;
use Grid;



my @grid = < a b c d e f g h i j k l m n o p >;
@grid does Grid[:4columns];


#plan 16;


# Subgrid test
my @subgrid-test = (
# [Subgrid Result]
[ [3, 4],                 False ], # @subgrid not valid
[ [1, 7],                 False ], # @subgrid not valid
[ [0 ... 4],              False ], # @subgrid not valid
[ [0 ... 4, 7],           False ], # @subgrid not valid
[ [0, 4, 8, 12, 16],      False ], # @subgrid not valid
[ [0, 4, 8, 12, 16, 20],  False ], # @subgrid not valid
[ [1, 5, 9, 13, 17, 21],  False ], # @subgrid not valid
[ [3, 7, 11, 15, 19, 23], False ], # @subgrid not valid

[ [0, 4],                 True ],
[ [0 ... 0],              True ],
[ [0 ... 1],              True ],
[ [0 ... 2],              True ],
[ [0 ... 3],              True ],
[ [0 ... 7],              True ],
[ [0 ... 15],             True ],
[ [9, 10, 13, 14],        True ],
);



for @subgrid-test -> [ @indices, $result ] {
  my $is-subgrid = @grid.has-subgrid(:@indices);
  ok $result === $is-subgrid, "subgrid";
}


# Grid test
my @indices = 5, 6, 9, 10;
my @grid-test = (
# [Method Subgrid Result]
[ <vertical-flip>,   [0, 4],     < e b c d a f g h i j k l m n o p > ],
[ <vertical-flip>,   [0 ... 1],  < a b c d e f g h i j k l m n o p > ],
[ <vertical-flip>,   [0 ... 3],  < a b c d e f g h i j k l m n o p > ],
[ <vertical-flip>,   [0 ... 7],  < e f g h a b c d i j k l m n o p > ],
[ <vertical-flip>,   [0 ... 15], < m n o p i j k l e f g h a b c d > ],
[ <vertical-flip>,   @indices,   < a b c d e j k h i f g l m n o p > ],

[ <horizontal-flip>, [0, 4],     < a b c d e f g h i j k l m n o p > ],
[ <horizontal-flip>, [0 ... 2],  < c b a d e f g h i j k l m n o p > ],
[ <horizontal-flip>, [0 ... 3],  < d c b a e f g h i j k l m n o p > ],
[ <horizontal-flip>, [0 ... 7],  < d c b a h g f e i j k l m n o p > ],
[ <horizontal-flip>, [0 ... 15], < d c b a h g f e l k j i p o n m > ],
[ <horizontal-flip>, [0 ... 1],  < b a c d e f g h i j k l m n o p > ],
[ <horizontal-flip>, @indices,   < a b c d e g f h i k j l m n o p > ],
[ <diagonal-flip>, @indices,   < a b c d e f j h i g k l m n o p > ],
[ <antidiagonal-flip>, @indices,   < a b c d e k g h i j f l m n o p > ],

[ <transpose>, @indices,   < a b c d e f j h i g k l m n o p > ],
[ <clockwise-rotate>, @indices,   < a b c d e j f h i k g l m n o p > ],
[ <anticlockwise-rotate>, @indices,   < a b c d e g k h i f j l m n o p > ],
);

for @grid-test -> [ $method, @indices, @expected ] {
  my @grid = < a b c d e f g h i j k l m n o p >;
  @grid does Grid[:4columns];
  my @result = @grid."$method"(:@indices);
  is @result, @expected, $method;
}

# Other tests
my @column = 0, 1, 2, 3;
my @row = 0, 1, 2, 3;


is @grid.append-column(:@column), < a b c d 0 e f g h 1 i j k l 2 m n o p 3 >, 'append-column';
is @grid.pop-columns(),           < a b c d e f g h i j k l m n o p >,         'pop-column';
is @grid.append-row(:@row),       < a b c d e f g h i j k l m n o p 0 1 2 3 >, 'append-row';
is @grid.pop-rows(),              < a b c d e f g h i j k l m n o p >,         'pop-row';


done-testing;

