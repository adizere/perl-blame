use strict;
use warnings;


use Test::More 'no_plan';


use_ok( 'Logger::Message' );

can_ok( 'Logger::Message', 'new' );
my $msg = Logger::Message->new();
isa_ok( $msg, 'Logger::Message' );

can_ok( $msg, 'timestamp' );
can_ok( $msg, 'level' );
can_ok( $msg, 'content' );

ok ( $msg->content() eq '', 'Default content empty string ok.');

my $msg_content = 'Sample Message Content';
$msg->content( $msg_content );
ok( $msg->content() eq $msg_content, 'Message content update ok.');

use Logger qw( DEBUG );
my $msg_lvl = DEBUG;
$msg->level( $msg_lvl );
ok ( $msg->level() eq $msg_lvl, 'Message level update ok.');

can_ok ( $msg, 'header' );
my $header = 'header';
$msg->header( $header );
ok ( $msg->header() eq $header, 'Header change ok.' );
