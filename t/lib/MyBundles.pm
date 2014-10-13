package
    MyBundles;

use strict;
use warnings;
use base 'Import::Base';

sub modules {
    my ( $class, $bundles, $args ) = @_;
    my @modules = ();
    my %bundles = (
        with_strict => [ 'strict' ],
        with_warnings => [ 'warnings' ],
    );
    return $class->SUPER::modules( $bundles, $args ),
        @modules,
        map { @{ $bundles{ $_ } } } grep { exists $bundles{ $_ } } @$bundles;
}

1;
