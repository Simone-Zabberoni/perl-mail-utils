#!/usr/bin/perl
#
# Requirements:
#   perl-Mail-POP3Client
#   http://search.cpan.org/~sdowd/Mail-POP3Client-2.16/POP3Client.pm
#
#   SSL Socket
#   perl-IO-Socket-SSL
#
# On Centos:
#   yum -y install perl-Mail-POP3Client perl-IO-Socket-SSL

use Mail::POP3Client;
use IO::Socket::SSL;

$pophost = 'pop3s.aruba.it';
$popport = 995;
$popuser = 'user@domain.tld';
$poppass = 'somepassword';

my $socket = IO::Socket::SSL->new(  PeerAddr        => $pophost,
                                    PeerPort        => $popport,
                                    SSL_verify_mode => SSL_VERIFY_NONE,
                                    Proto           => 'tcp') 
or die $pophost.":".$popport." -> ".$!;


my $pop = Mail::POP3Client->new();
$pop->User($popuser);
$pop->Pass($poppass);
$pop->Socket($socket);
$pop->Connect() or die "Unable to connect to POP3 server: ".$pop->Message()."\n"; 

for( $i = 1; $i <= $pop->Count(); $i++ ) {
    foreach($pop->Head($i)) {
        $subj = $1 if /Subject:\s(.+)/i;
        $from = $1 if /From:\s(.+)/i;
    }
    print $from . " : " . $subj . "\n";
}




