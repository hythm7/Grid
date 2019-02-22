NAME
====

Grid - Role for Arrays.

SYNOPSIS
========

    use Grid;

    my @grid = < a b c d e f g h i j k l m n o p q r s t u v w x >;

    @grid does Grid[:4columns];

DESCRIPTION
===========

Grid is a `Role` that transforms an `Array` to `Array+{Grid}`, And provides additional methods (e.g flip, rotate, transpose).

To flip a `Grid` horizontaly or vertically:

    @grid.flip: :horizontal
    @grid.flip: :vertical
    
It is also possible to apply methods to a subgrid of `Grid`, provided a valid subgrid indices:

    my @indices  = 9, 10, 13, 14; @grid.flip: :vertical(@indices); # or
    my @vertical = 9, 10, 13, 14; @grid.flip: :@vertical;`

`Grid` preserves the overall shape, So some operations require `is-square` to be `True`  for `Grid` (or Subgrid), otherwise fails and returns `self`.


LIMITATIONS
===========

Direct modification of `Grid` with methods like `push`, `unshift`, `append` or `prepend` may lead to unexpected behavior, Please use `Role`'s methods (e.g. `append-row`, `append-column`).


Methods
=======

### grid

    method grid () { ... }

Prints a `:$!columns` `Grid` of the Array elements.


### flip

    multi method flip ( Grid:D: Int:D :$horizontal! --> Grid:D ) { ... }
Horizontal Flip.

    multi method flip ( Grid:D: Int:D :$vertical! --> Grid:D ) { ... }
Verical Flip.

    multi method flip ( Grid:D: Int:D :$diagonal! --> Grid:D ) { ... }
Diagonal Flip.

    multi method flip ( Grid:D: Int:D :$antidiagonal! --> Grid:D ) { ... }
Anti-Diagonal Flip.

    multi method flip ( Grid:D: :@horizontal! --> Grid:D ) { ... }
Horizontal Flip (Subgrid).

    multi method flip ( Grid:D: :@vertical! --> Grid:D ) { ... }
Vertical Flip (Subgrid).

    multi method flip ( Grid:D: :@diagonal! --> Grid:D ) { ... }
Diagonal Flip (Subgrid).

    multi method flip ( Grid:D: :@antidiagonal! --> Grid:D ) { ... }
Anti-Diagonal Flip (Subgrid).


### rotate

    multi method rotate ( Grid:D:  Int:D :$left! --> Grid:D ) { ... }
Left Rotate. (Columns)

    multi method rotate ( Grid:D:  Int:D :$right! --> Grid:D ) { ... }
Right Rotate. (Columns)

    multi method rotate ( Grid:D:  Int:D :$up! --> Grid:D ) { ... }
Up Rotate. (Rows)

    multi method rotate ( Grid:D:  Int:D :$down! --> Grid:D ) { ... }
Up Rotate. (Rows)

    multi method rotate ( Grid:D: Int:D :$clockwise! --> Grid:D ) { ... }
Clockwise Rotate.

    multi method rotate ( Grid:D: Int:D :$anticlockwise! --> Grid:D ) { ... }
Anti-Clockwise Rotate.

    multi method rotate ( Grid:D: :@clockwise! --> Grid:D ) { ... }
Clockwise Rotate (Subgrid)

    multi method rotate ( Grid:D: :@anticlockwise! --> Grid:D ) { ... }
Clockwise Rotate (Subgrid)


### transpose

    multi method transpose ( Grid:D: --> Grid:D ) { ... }
Transpose.

    multi method transpose ( Grid:D: :@indices! --> Grid:D ) { ... }
Transpose (Subgrid)


### append

    multi method append ( Grid:D: :@row! --> Grid:D ) { ... }
Append Row.

    multi method append ( Grid:D: :@column! --> Grid:D ) { ... }
Append Column.

    multi method prepend ( Grid:D: :@row! --> Grid:D ) {
Prepend Row.

    multi method prepend ( Grid:D: :@column! --> Grid:D ) { ... }
Prepend Column.


### pop

    multi method pop ( Grid:D:  Int :$rows! --> Grid:D ) { ... }
Pop Rows.

    multi method pop ( Grid:D:  Int :$columns! --> Grid:D ) { ... }
Pop Columns.


### shift

    multi method shift ( Grid:D:  Int :$rows! --> Grid:D ) { ... }
Shift Rows.

    multi method shift ( Grid:D:  Int :$columns! --> Grid:D ) { ... }
Shift Columns.


### has-subgrid

    method has-subgrid( :@indices!, :$square = False --> Bool:D ) { ... }
Returns `True` if `:@indices` is a subgrid of `Grid`, `False` otherwise.


### is-subgrid

    method is-square ( --> Bool:D ) { ... }
Returns `True` if `Grid` is a square, `False` otherwise.


Examples
--------

### grid

<code>

    @grid.grid;

    a b c d
    e f g h
    i j k l
    m n o p
    q r s t
    u v w x

</code>


### flip

<code>

    a b c d                          **d c b a** 
    e f g h                          **h g f e**
    i j k l       :horizontal        **l k j i**
    m n o p    ----------------->    **p o n m**
    q r s t                          **t s r q**
    u v w x                          **x w v u**


    a b c d                          **u v w x**
    e f g h                          **q r s t**
    i j k l        :vertical         **m n o p**
    m n o p    ----------------->    **i j k l**
    q r s t                          **e f g h**
    u v w x                          **a b c d**


    a b c d                          a b c d
    e f g h                          e f g h
    i j k l        :diagonal         i j k l
    m n o p    ----------------->    m n o p
    q r s t                          q r s t
    u v w x                          u v w x
    # fails becuase Grid.is-square === `False`


    a b c d                          a b c d
    e f g h                          **e i m q**
    i j k l       :@diagonal         **f j n r**
    m n o p    ----------------->    **g k o s**
    q r s t        4 ... 19          **h l p t**
    u v w x                          u v w x


    a b c d                          a b c d
    e f g h                          **t p l h**
    i j k l     :@antidiagonal       **s o k g**
    m n o p    ----------------->    **r n j f**
    q r s t      [ 4 ... 19 ]        **q m i e**
    u v w x                          u v w x

</code>


### rotate

<code>

    a b c d                          **d a b c** 
    e f g h                          **h e f g**
    i j k l         :right           **l i j k**
    m n o p    ----------------->    **p m n o**
    q r s t                          **t q r s**
    u v w x                          **x u v w**


    a b c d                          **c d a b** 
    e f g h                          **g h e f**
    i j k l         :2left           **k l i j**
    m n o p    ----------------->    **o p m n**
    q r s t                          **s t q r**
    u v w x                          **w x u v**


    a b c d                          **m n o p** 
    e f g h                          **q r s t**
    i j k l         :3down           **u v w x**
    m n o p    ----------------->    **a b c d**
    q r s t                          **e f g h**
    u v w x                          **i j k l**


    a b c d                          **e f g h** 
    e f g h                          **i j k l**
    i j k l          :7up            **m n o p**
    m n o p    ----------------->    **q r s t**
    q r s t                          **u v w x**
    u v w x                          **a b c d**


    a b c d
    e f g h                          **u q m i e a**
    i j k l       :clockwise         **v r n j f b**
    m n o p    ----------------->    **w s o k g c**
    q r s t                          **x t p l h d**
    u v w x


    a b c d                          a b c d
    e f g h                          e f g h
    i j k l     :@anticlockwise      i **k o** l
    m n o p    ----------------->    m **j n** p
    q r s t    [ 9, 10, 13, 14 ]     q r s t
    u v w x                          u v w x


</code>

### transpose

<code>

    a b c d
    e f g h                          **a e i m q u**
    i j k l                          **b f j n r v**
    m n o p    ----------------->    **c g k o s w**
    q r s t                          **d h l p t x**
    u v w x


    a b c d                          a b c d
    e f g h                          e f g h
    i j k l        :@indices         i **j n** l
    m n o p    ----------------->    m **k o** p
    q r s t    [ 9, 10, 13, 14 ]     q r s t
    u v w x                          u v w x


    a b c d                          a b c d
    e f g h                          e f g h
    i j k l       :@indices          i j k l
    m n o p    ---------------->     m n o p
    q r s t  [ 5, 6, 9, 10, 13, 14 ] q r s t
    u v w x                          u v w x
    # fails becuase Subgrid.is-square === False


</code>

### append

<code>

    a b c d                          a b c d
    e f g h                          e f g h
    i j k l       :@row              i j k l
    m n o p    ----------------->    m n o p
    q r s t    [ 0, 1, 2, 3 ]        q r s t
    u v w x                          u v w x
                                   **0 1 2 3**

    a b c d                          a b c d **0**
    e f g h                          e f g h **1**
    i j k l       :@column           i j k l **2**
    m n o p    ----------------->    m n o p **3**
    q r s t   [ 0, 1, 2, 3, 4, 5 ]   q r s t **4**
    u v w x                          u v w x **5**
  

</code>

### prepend

<code>

    a b c d                          **0 1 2 3**
    e f g h                          a b c d
    i j k l         :@row            e f g h
    m n o p    ----------------->    i j k l
    q r s t      [ 0, 1, 2, 3 ]      m n o p
    u v w x                          q r s t
                                     u v w x

    a b c d                          **0**a b c d
    e f g h                          **1**e f g h
    i j k l       :@column           **2**i j k l
    m n o p    ----------------->    **3**m n o p
    q r s t   [ 0, 1, 2, 3, 4, 5 ]   **4**q r s t
    u v w x                          **5**u v w x

</code>


### pop

<code>

    a b c d
    e f g h                          a b c d
    i j k l        :2rows            e f g h
    m n o p    ----------------->    i j k l
    q r s t                          m n o p
    u v w x


    a b c d                          a b c
    e f g h                          e f g
    i j k l       :1columns          i j k
    m n o p    ----------------->    m n o
    q r s t                          q r s
    u v w x                          u v w


</code>

### shift

<code>

    a b c d
    e f g h                          i j k l
    i j k l         :2rows           m n o p
    m n o p    ----------------->    q r s t 
    q r s t                          u v w x
    u v w x


    a b c d                          d
    e f g h                          h
    i j k l        :1columns         l
    m n o p    ----------------->    p
    q r s t                          t
    u v w x                          x

</code>


AUTHOR
======

Haytham Elganiny <elganiny.haytham@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2019 Haythem Elganiny

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

