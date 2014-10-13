package
    MyInheritedBundles;

use strict;
use warnings;
use base 'MyBundles';

sub modules {
    my ( $class, $bundles, $args ) = @_;
    my @modules = ();
    my %bundles = (
        with_strict => [ 'warnings' ],
    );
    return $class->SUPER::modules( $bundles, $args ),
        @modules,
        map { @{ $bundles{ $_ } } } grep { exists $bundles{ $_ } } @$bundles;
}

1;
