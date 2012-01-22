use strict;
use warnings;


use Test::More 'no_plan';


my @fclasees = qw(
    Apollo::Logger
    Apollo::Logger::Entry
    Apollo::Logger::Delegates::File
    Apollo::Logger::Levels
);

foreach( @fclasees ) {
    use_ok( $_ ) || print "Can't use $_\n";
}
