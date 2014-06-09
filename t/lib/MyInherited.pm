package
    MyInherited;

use strict;
use warnings;
use base 'MyImporter';

sub modules {
    my ( $class, %args ) = @_;
    return (
        $class->SUPER::modules,
        'Carp' => [qw( carp )],
    );
}

1;
