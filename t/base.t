
use strict;
use warnings;
use lib 't/lib';
use Test::More;
use Test::Import import => [qw( :all )];

subtest 'simple base module' => sub {
    does_import_strict 'MyImporter';
    does_import_warnings 'MyImporter';
    does_import_sub 'MyImporter', 'Module::Runtime', 'use_module';
};

subtest 'inherited base module' => sub {
    does_import_strict 'MyInherited';
    does_import_warnings 'MyInherited';
    does_import_sub 'MyInherited', 'Module::Runtime', 'use_module';
    does_import_sub 'MyInherited', 'Carp', 'carp';
};

done_testing;
