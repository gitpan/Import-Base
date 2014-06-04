
use strict;
use warnings;
use lib 't/lib';
use Test::More;

subtest 'Exclude a certain strict category' => sub {
    eval q{
        package no::strict;
        no strict;
        use MyUnstrict;
        $foo = 0; # strict vars is off
        my $bar = "foo";
        print $$bar; # strict refs is on
    };

    unlike $@, qr/\QGlobal symbol "\$foo" requires explicit package name/;
    like $@, qr/\QCan't use string ("foo") as a SCALAR ref while "strict refs" in use at/;
};

done_testing;
