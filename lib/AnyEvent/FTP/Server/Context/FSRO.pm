package AnyEvent::FTP::Server::Context::FSRO;

use strict;
use warnings;
use v5.10;
use Moo;
use warnings NONFATAL => 'all';

extends 'AnyEvent::FTP::Server::Context::FSRW';

# ABSTRACT: FTP Server client context class with read-only access
our $VERSION = '0.02'; # VERSION


sub cmd_stor
{
  my($self, $con, $req) = @_;
  unless(defined $self->data)
  { $con->send_response(425 => 'Unable to build data connection') }
  else
  { $con->send_response(553 => "Permission denied") }
  $self->done;
}


*cmd_appe = \&cmd_stor;


*cmd_stou = \&cmd_stor;
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Server::Context::FSRO - FTP Server client context class with read-only access

=head1 VERSION

version 0.02

=head1 SYNOPSIS

 use AnyEvent::FTP::Server;
 
 my $server = AnyEvent::FTP::Server->new(
   default_context => 'AnyEvent::FTP::Server::Context::FSRO',
 );

=head1 DESCRIPTION

This class provides a context for L<AnyEvent::FTP::Server> which uses the
actual filesystem to provide storage.

=head1 SUPER CLASS

This class inherits from

L<AnyEvent::FTP::Server::Context::FSRW>

=head1 COMMANDS

In addition to the commands provided by the above user class,
this context provides these FTP commands:

=over 4

=item STOR

=item APPE

=item STOU

=back

=cut

=head1 AUTHOR

author: Graham Ollis <plicease@cpan.org>

contributors:

Ryo Okamoto

Shlomi Fish

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
