package Import::Base;
{
  $Import::Base::VERSION = '0.001';
}
# ABSTRACT: Import a set of modules into the calling module

use strict;
use warnings;
use Import::Into;
use Module::Runtime qw( use_module );

sub modules {
    return ();
}

sub import {
    my ( $class, %args ) = @_;
    my $caller = caller;
    my @modules = $class->modules( %args );
    while ( @modules ) {
        my $module = shift @modules;
        my $imports = ref $modules[0] eq 'ARRAY' ? shift @modules : [];
        use_module( $module )->import::into( $caller, @{ $imports } );
    }
}

1;

__END__

=pod

=head1 NAME

Import::Base - Import a set of modules into the calling module

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    package My::Base;
    use base 'Import::Base';
    sub modules {
        my ( $class, %args ) = @_;
        return (
            strict => [],
            warnings => [],
        );
    }
    1;

    package My::Module;
    use My::Base;

=head1 DESCRIPTION

This module makes it easier to build and manage a base set of imports. Rather
than importing a dozen modules in each of your project's modules, you simply
import one module and get all the other modules you want. This reduces your
module boilerplate from 12 lines to 1.

=head1 METHODS

=head2 modules( %args )

Prepare the list of modules to import. %args comes from the caller's C<use> line.
Returns a list of MODULE => [ import() args ]. MODULE may appear multiple times.

=head1 SEE ALSO

=over

=item L<ToolSet|ToolSet>

This is very similar, but does not appear to allow subclasses to remove imports from
the list of things to be imported. By having the module list be a static array, we
can modify it further in more levels of subclasses.

=item L<Toolkit|Toolkit>

This one requires configuration files in a home directory, so is not shippable.

=item L<rig|rig>

This one also requires configuration files in a home directory, so is not shippable.

=back

=head1 AUTHOR

Doug Bell <preaction@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Doug Bell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
