
use strict;
use warnings;
use lib 't/lib';
use Test::More;

subtest 'named bundle' => sub {
    subtest 'bundle with strict' => sub {
        eval q{
            package bundle::strict;
            no strict;
            use MyBundles qw( with_strict );
            $foo = 0;
        };
        like $@, qr/Global symbol "\$foo" requires explicit package name/;

        subtest 'no bundle' => sub {
            eval q{
                package bundle::nostrict;
                no strict;
                use MyBundles;
                $foo = 0;
            };
            unlike $@, qr/Global symbol "\$foo" requires explicit package name/;
        };
    };

    subtest 'bundle with warnings' => sub {
        my $warn;
        local $SIG{__WARN__} = sub { $warn = $_[0] };
        eval q{
            package bundle::warnings;
            no warnings;
            use MyBundles qw( with_warnings );
            my $foo = 0 + "foo";
        };
        like $warn, qr/Argument "foo" isn't numeric in addition/;

        subtest 'no bundle' => sub {
            my $warn;
            local $SIG{__WARN__} = sub { $warn = $_[0] };
            eval q{
                package bundle::nowarnings;
                no warnings;
                use MyBundles;
                my $foo = 0 + "foo";
            };
            unlike $warn, qr/Argument "foo" isn't numeric in addition/;
        };
    };
};

subtest 'inherited bundles' => sub {
    subtest 'bundle with strict' => sub {
        eval q{
            package inheritedbundle::strict;
            no strict;
            use MyInheritedBundles qw( with_strict );
            $foo = 0;
        };
        like $@, qr/Global symbol "\$foo" requires explicit package name/;
    };

    subtest 'bundle also adds warnings' => sub {
        my $warn;
        local $SIG{__WARN__} = sub { $warn = $_[0] };
        eval q{
            package inheritedbundle::warnings;
            no warnings;
            use MyInheritedBundles qw( with_strict );
            my $foo = 0 + "foo";
        };
        like $warn, qr/Argument "foo" isn't numeric in addition/;
    };
};

done_testing;
