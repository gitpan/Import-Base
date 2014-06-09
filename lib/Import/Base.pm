package Import::Base;
# ABSTRACT: Import a set of modules into the calling module
$Import::Base::VERSION = '0.004';
use strict;
use warnings;
use Import::Into;
use Module::Runtime qw( use_module );

sub modules {
    return ();
}

sub import {
    my ( $class, %args ) = @_;

    die "Argument to -exclude must be arrayref"
        if $args{-exclude} && ref $args{-exclude} ne 'ARRAY';
    my $exclude = {};
    if ( $args{-exclude} ) {
        while ( @{ $args{-exclude} } ) {
            my $module = shift @{ $args{-exclude} };
            my $subs = ref $args{-exclude}[0] eq 'ARRAY' ? shift @{ $args{-exclude} } : undef;
            $exclude->{ $module } = $subs;
        }
    }

    my @modules = $class->modules( %args );
    while ( @modules ) {
        my $module = shift @modules;
        my $imports = ref $modules[0] eq 'ARRAY' ? shift @modules : [];

        if ( exists $exclude->{ $module } ) {
            if ( defined $exclude->{ $module } ) {
                my @left;
                for my $import ( @$imports ) {
                    push @left, $import
                        unless grep { $_ eq $import } @{ $exclude->{ $module } };
                }
                $imports = \@left;
            }
            else {
                next;
            }
        }

        my $method = 'import::into';
        if ( $module =~ /^-/ ) {
            $method = 'unimport::out_of';
            $module =~ s/^-//;
        }

        use_module( $module )->$method( 1, @{ $imports } );
    }
}

1;

__END__

=pod

=head1 NAME

Import::Base - Import a set of modules into the calling module

=head1 VERSION

version 0.004

=head1 SYNOPSIS

    package My::Base;
    use base 'Import::Base';
    sub modules {
        my ( $class, %args ) = @_;
        return (
            'strict',
            'warnings',
            'My::Exporter' => [ 'foo', 'bar', 'baz' ],
            '-warnings' => [qw( experimental::signatures )],
        );
    }

    package My::Module;
    use My::Base;

    package My::Other;
    use My::Base -exclude => [ 'warnings', 'My::Exporter' => [ 'bar' ] ];

=head1 DESCRIPTION

This module makes it easier to build and manage a base set of imports. Rather
than importing a dozen modules in each of your project's modules, you simply
import one module and get all the other modules you want. This reduces your
module boilerplate from 12 lines to 1.

=head1 USAGE

=head2 Base Module

Creating a base module means extending Import::Base and overriding sub modules().
modules() returns a list of modules to import, optionally with a arrayref of arguments
to be passed to the module's import() method.

A common base module should probably include L<strict|strict>,
L<warnings|warnings>, and a L<feature|feature> set.

    package My::Base;
    use base 'Import::Base';

    sub modules {
        my ( $class, %args ) = @_;
        return (
            'strict',
            'warnings',
            feature => [qw( :5.14 )],
        );
    }

Now we can consume our base module by doing:

    package My::Module;
    use My::Base;

Which is equivalent to:

    package My::Module;
    use strict;
    use warnings;
    use feature qw( :5.14 );

Now when we want to change our feature set, we only need to edit one file!

=head2 Extended Base Module

We can further extend our base module to create more specialized modules for
classes and testing.

    package My::Class;
    use base 'My::Base';

    sub modules {
        my ( $class, %args ) = @_;
        return (
            $class->SUPER::modules( %args ),
            'Moo::Lax',
            'Types::Standard' => [qw( :all )],
        );
    }

    package My::Test;
    use base 'My::Base';

    sub modules {
        my ( $class, %args ) = @_;
        return (
            $class->SUPER::modules( %args ),
            'Test::More',
            'Test::Deep',
            'Test::Exception',
            'Test::Differences',
        );
    }

Now all our classes just need to C<use My::Class> and all our test scripts just
need to C<use My::Test>.

=head2 Unimporting

Sometimes instead of C<use Module> we need to do C<no Module>, to turn off
C<strict> or C<warnings> categories for example.

By prefixing the module name with a C<->, Import::Base will act like C<no>
instead of C<use>.

    package My::Base;
    use base 'Import::Base';

    sub modules {
        my ( $class, %args ) = @_;
        return (
            'strict',
            'warnings',
            feature => [qw( :5.20 )],
            '-warnings' => [qw( experimental::signatures )],
        );
    }

Now the warnings for using the 5.20 subroutine signatures feature will be
disabled.

=head2 -exclude

When importing a base module, you can use C<-exclude> to prevent certain things
from being imported (if, for example, they would conflict with existing
things).

    # Prevent the "warnings" module from being imported
    use My::Base -exclude => [ 'warnings' ];

    # Prevent the "bar" sub from My::Exporter from being imported
    use My::Base -exclude => [ 'My::Exporter' => [ 'bar' ] ];

NOTE: If you find yourself using C<-exclude> often, you would be better off
removing the module or sub and only including it in those modules that need it.

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
