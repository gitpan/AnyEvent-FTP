package AnyEvent::FTP::Client::Site::Microsoft;

use strict;
use warnings;
use v5.10;
use Moo;
use warnings NONFATAL => 'all';

extends 'AnyEvent::FTP::Client::Site::Base';

# ABSTRACT: Site specific commands for Microsoft FTP Service
our $VERSION = '0.01'; # VERSION


# TODO add a test for this
sub dirstyle { shift->client->push_command([SITE => 'DIRSTYLE'] ) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Client::Site::Microsoft - Site specific commands for Microsoft FTP Service

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use AnyEvent::FTP::Client;
 my $client = AnyEvent::FTP::Client->new;
 $client->connect('ftp://iisserver')->cb(sub {
   # toggle dir style
   $client->site->microsoft->dirstyle->cb(sub {
   
     $client->list->cb(sub {
       my $list = shift
       # $list is in first style.
       
       $client->site->microsoft->dirstyle->cb(sub {
       
         $client->list->cb(sub {
           my $list = shift;
           # list is in second style.
         });
       
       });
     });
   
   });
 });

=head1 DESCRIPTION

This class provides Microsoft's IIS SITE commands.

=head1 METHODS

=head2 $client-E<gt>site-E<gt>microsoft-E<gt>dirstyle

Toggle between directory listing output styles.

=head1 AUTHOR

Graham Ollis <plicease@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
