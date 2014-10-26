
use strict;
use warnings;
use lib 't/lib';
use Test::More;

subtest 'static API' => sub {
    subtest 'common imports' => sub {
        eval q{
            package static::no::strict;
            no strict;
            use MyStatic;
            $foo = 0;
        };

        like $@, qr/Global symbol "\$foo" requires explicit package name/;

        my $warn;
        local $SIG{__WARN__} = sub { $warn = $_[0] };
        eval q{
            package static::no::warnings;
            no warnings;
            use MyStatic;
            my $foo = 0 + "foo";
        };
        like $warn, qr/Argument "foo" isn't numeric in addition/;
    };

    subtest 'bundles' => sub {
        subtest 'no bundles are imported by default' => sub {
            eval q{
                package static::without::bundle;
                no strict; no warnings;
                use MyStatic;
                catdir( "", "foo" );
            };

            like $@, qr/\QUndefined subroutine &static::without::bundle::catdir called/;
        };

        subtest 'bundle imports sub' => sub {
            eval q{
                package static::with::bundle;
                no strict; no warnings;
                use MyStatic 'Spec';
                catdir( "", "foo" );
            };

            unlike $@, qr/\QUndefined subroutine &static::with::bundle::catdir called/;
        };

        subtest 'bundle unimports' => sub {
            my $warn;
            local $SIG{__WARN__} = sub { $warn = $_[0] };
            eval q{
                package static::with::bundle::unimport;
                no strict; no warnings;
                use MyStatic 'lax';
                my $foo;
                my $bar = $foo . " bar";
            };
            unlike $warn, qr/Use of uninitialized value \$foo in concatenation/;
        };
    };

    subtest 'inheritance' => sub {
        subtest 'common imports' => sub {
            eval q{
                package static::no::inherited::strict;
                no strict;
                use MyStaticInherits;
                $foo = 0;
                $bar = "foo";
                $$bar = 1;
            };

            unlike $@, qr/Global symbol "\$foo" requires explicit package name/;
            like $@, qr/\QCan't use string ("foo") as a SCALAR ref/;
        };

        subtest 'bundles' => sub {
            subtest 'no bundles are imported by default' => sub {
                eval q{
                    package static::without::inherited::bundle;
                    no strict; no warnings;
                    use MyStaticInherits;
                    catfile( "", "foo" );
                };

                like $@, qr/\QUndefined subroutine &static::without::inherited::bundle::catfile called/;
            };

            eval q{
                package static::with::inherited::bundle;
                no strict; no warnings;
                use MyStaticInherits 'Spec';
                catfile( "", "foo" );
                catdir( "", "foo" );
            };

            unlike $@, qr/\QUndefined subroutine &static::with::inherited::bundle::catdir called/;
            unlike $@, qr/\QUndefined subroutine &static::with::inherited::bundle::catfile called/;
        };
    };
};

subtest 'dynamic API' => sub {
    subtest 'common imports' => sub {
        eval q{
            package dynamic::no::strict;
            no strict;
            use MyDynamic;
            $foo = 0;
        };

        like $@, qr/Global symbol "\$foo" requires explicit package name/;

        my $warn;
        local $SIG{__WARN__} = sub { $warn = $_[0] };
        eval q{
            package dynamic::no::warnings;
            no warnings;
            use MyDynamic;
            my $foo = 0 + "foo";
        };
        like $warn, qr/Argument "foo" isn't numeric in addition/;
    };

    subtest 'bundles' => sub {
        subtest 'no bundles are imported by default' => sub {
            eval q{
                package dynamic::without::bundle;
                no strict; no warnings;
                use MyDynamic;
                catdir( "", "foo" );
            };

            like $@, qr/\QUndefined subroutine &dynamic::without::bundle::catdir called/;
        };

        subtest 'bundle imports sub' => sub {
            eval q{
                package dynamic::with::bundle;
                no strict; no warnings;
                use MyDynamic 'Spec';
                catdir( "", "foo" );
            };

            unlike $@, qr/\QUndefined subroutine &dynamic::with::bundle::catdir called/;
        };

        subtest 'bundle unimports' => sub {
            my $warn;
            local $SIG{__WARN__} = sub { $warn = $_[0] };
            eval q{
                package dynamic::with::bundle::unimport;
                no strict; no warnings;
                use MyDynamic 'lax';
                my $foo;
                my $bar = $foo . " bar";
            };
            unlike $warn, qr/Use of uninitialized value \$foo in concatenation/;
        };
    };

    subtest 'inheritance' => sub {
        subtest 'common imports' => sub {
            eval q{
                package dynamic::no::inherited::strict;
                no strict;
                use MyDynamicInherits;
                $foo = 0;
                $bar = "foo";
                $$bar = 1;
            };

            unlike $@, qr/Global symbol "\$foo" requires explicit package name/;
            like $@, qr/\QCan't use string ("foo") as a SCALAR ref/;
        };

        subtest 'bundles' => sub {
            subtest 'no bundles are imported by default' => sub {
                eval q{
                    package dynamic::without::inherited::bundle;
                    no strict; no warnings;
                    use MyDynamicInherits;
                    catfile( "", "foo" );
                };

                like $@, qr/\QUndefined subroutine &dynamic::without::inherited::bundle::catfile called/;
            };

            eval q{
                package dynamic::with::inherited::bundle;
                no strict; no warnings;
                use MyDynamicInherits 'Spec';
                catfile( "", "foo" );
                catdir( "", "foo" );
            };

            unlike $@, qr/\QUndefined subroutine &dynamic::with::inherited::bundle::catdir called/;
            unlike $@, qr/\QUndefined subroutine &dynamic::with::inherited::bundle::catfile called/;
        };
    };
};

done_testing;
