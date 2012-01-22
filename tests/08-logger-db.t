use strict;
use warnings;


use Test::More 'no_plan';


use Logger qw( log add_delegate );
use Logger::Delegates::Db qw( DBLOG_HANDLER_INIT DBLOG_PARAMS_INIT );


# initialization methods...
# with DB parameters
my $delegate = Logger::Delegates::Db->new({
    init_type => DBLOG_PARAMS_INIT,
    log_name => 'db_logger_test_5',
    driver_name => 'mysql',
    username => 'root',
    password => 'root',
    host => 'localhost',
    port => '3306',
    database => 'db_logger_test',
});



isnt ( $delegate, undef, 'Ok Stderr delegate creation' );


add_delegate( $delegate );


$delegate = Logger::Delegates::Db->new({
    init_type => DBLOG_PARAMS_INIT,
    log_name => 'db_logger_test_4',
    driver_name => 'mysql',
    username => 'root',
    password => 'root',
    host => 'localhost',
    port => '3306',
    database => 'db_logger_test',
});


isnt ( $delegate, undef, 'Ok Stderr delegate creation' );


add_delegate( $delegate );


log( 'Testul suprem' );
