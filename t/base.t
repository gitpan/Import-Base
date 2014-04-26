
use strict;
use warnings;
use lib 't/lib';
use Test::Most;
use Test::Import import => [qw( :all )];

does_import_strict 'MyImporter';
does_import_warnings 'MyImporter';
does_import_sub 'MyImporter', 'Module::Runtime', 'use_module';
done_testing;
