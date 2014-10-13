package
    MyInherited;

use strict;
use warnings;
use base 'MyImporter';

sub modules {
    my ( $class, $bundles, $args ) = @_;
    return (
        $class->SUPER::modules( $bundles, $args ),
        'Carp' => [qw( carp )],
    );
}

1;
