use strict;
use warnings;


use Test::More 'no_plan';


my @fclasees = qw(
    Logger
    Logger::Message
    Logger::Delegates::File
);

foreach( @fclasees ) {
    use_ok( $_ ) || print "Can't use $_\n";
}
