use strict;
use warnings;


use Test::More 'no_plan';


use_ok( 'Apollo::Logger::Entry' );

can_ok( 'Apollo::Logger::Entry', 'new' );
my $msg = Apollo::Logger::Entry->new();
isa_ok( $msg, 'Apollo::Logger::Entry' );

can_ok( $msg, 'timestamp' );
can_ok( $msg, 'level' );
can_ok( $msg, 'content' );

ok ( $msg->content() eq '', 'Default content empty string ok.');

my $msg_content = 'Sample Entry Content';
$msg->content( $msg_content );
ok( $msg->content() eq $msg_content, 'Entry content update ok.');

use Apollo::Logger::Levels qw( DEBUG );
my $msg_lvl = DEBUG;
$msg->level( $msg_lvl );
ok ( $msg->level() eq $msg_lvl, 'Entry level update ok.');

can_ok ( $msg, 'header' );
my $header = 'header';
$msg->header( $header );
ok ( $msg->header() eq $header, 'Header change ok.' );
