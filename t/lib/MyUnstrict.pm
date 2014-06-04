package
    MyUnstrict;

use strict;
use warnings;
use base 'Import::Base';

sub modules {
    strict => [],
    warnings => [],
    '-strict' => [ 'vars' ],
}

1;
