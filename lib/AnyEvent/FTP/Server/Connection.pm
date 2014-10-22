package AnyEvent::FTP::Server::Connection;

use strict;
use warnings;
use v5.10;
use Moo;
use warnings NONFATAL => 'all';
use AnyEvent::FTP::Request;

# ABSTRACT: FTP Server connection class
our $VERSION = '0.04'; # VERSION

with 'AnyEvent::FTP::Role::Event';

__PACKAGE__->define_events(qw( request response close ));

has context => (
  is       => 'ro',
  required => 1,
);

has response_encoder => (
  is => 'ro',
  lazy => 1,
  default => sub {
    require AnyEvent::FTP::Server::UnambiguousResponseEncoder;
    AnyEvent::FTP::Server::UnambiguousResponseEncoder->new;
  },
);

has ip => (
  is       => 'ro',
  required => 1,
);

sub process_request
{
  my($self, $line) = @_;

  my $raw = $line;
  
  $self->emit(request => $raw);
  
  $line =~ s/\015?\012//g;

  if($line =~ s/^([A-Z]{1,4})\s?//i)
  {
    $self->context->push_request($self, AnyEvent::FTP::Request->new(uc $1, $line, $raw));
  }
  else
  {
    $self->context->invalid_syntax($self, $raw);
  }
  
  $self;
}

sub send_response
{
  my $self = shift;
  my $raw = $self->response_encoder->encode(@_);
  $self->emit(response => $raw);
  $self;
}

sub close
{
  my($self) = shift;
  $self->emit('close');
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Server::Connection - FTP Server connection class

=head1 VERSION

version 0.04

=head1 METHODS

=head2 $conn-E<gt>close()

Emits a close signal.

=head2 my $context_obj = $conn-E<gt>context()

Required to be specified by the constructor and readonly - this is the
context object.

=head2 my $ip = $conn-E<gt>ip();

Required to be specified by the constructor and readonly - this is the
IP address.

=head2 $conn-E<gt>process_request($line)

Process a single request. Returns the connection object ($conn).

=head2 $conn-E<gt>send_response([ $res | $code, $message ])

Sends the response. Returns the connection object ($conn).

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
