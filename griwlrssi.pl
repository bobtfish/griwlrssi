#!perl
#
# An irssi script that sends priv msgs and hilights to a socket

use strict;
use Irssi;
use IO::Socket;

sub send_to_growl {
    my ($title, $msg) = @_;
    my $socket = IO::Socket::INET->new(
        PeerHost => "localhost",
        PeerPort => 9942,
        Proto => "tcp",
    );
    if ($socket) {
        print $socket "$title\n$msg\n";
        close $socket;
    }
}

Irssi::signal_add_last('message private', sub {
    my (undef, $data, $nick) = @_;
    send_to_growl("<$nick>", $data);
});

Irssi::signal_add_last('print text', sub {
    my ($dest, undef, $stripped) = @_;
    if ($dest->{level} & MSGLEVEL_HILIGHT) {
        send_to_growl($dest->{target}, $stripped);
    }
});
