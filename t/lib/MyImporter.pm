package
    MyImporter;

use strict;
use warnings;
use base 'Import::Base';

sub modules {
    strict => [],
    warnings => [],
    'Module::Runtime' => [qw( use_module )],
}

1;
