use strict;
use warnings;


use Test::More 'no_plan';


my @fclasees = qw(
    Logger
    Logger::Entry
    Logger::Delegates::File
    Logger::Levels
);

foreach( @fclasees ) {
    use_ok( $_ ) || print "Can't use $_\n";
}
