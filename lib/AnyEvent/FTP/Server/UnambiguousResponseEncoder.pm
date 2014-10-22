package AnyEvent::FTP::Server::UnambiguousResponseEncoder;

use strict;
use warnings;
use v5.10;
use Moo;
use warnings NONFATAL => 'all';

# ABSTRACT: Server response encoder that encodes responses so they cannot be confused
our $VERSION = '0.03'; # VERSION


with 'AnyEvent::FTP::Server::Role::ResponseEncoder';


sub encode
{
  my $self = shift;
  
  my $code;
  my $message;
  
  if(ref $_[0])
  {
    $code = $_[0]->code;
    $message = $_[0]->message;
  }
  else
  {
    ($code, $message) = @_;
  }
  
  $message = [ $message ] unless ref($message) eq 'ARRAY';
  
  my $last = pop @$message;
  
  return join "\015\012", (map { "$code-$_" } @$message), "$code $last\015\012";
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Server::UnambiguousResponseEncoder - Server response encoder that encodes responses so they cannot be confused

=head1 VERSION

version 0.03

=head1 SYNOPSIS

 use AnyEvent::FTP::Server::UnambiguousResponseEncoder;
 my $encoder = AnyEvent::FTP::Server::UnambiguousResponseEncoder->new;
 # encode a FTP welcome message
 my $message = $encoder->encode(220, 'welcome to myftpd');

=head1 DESCRIPTION

Objects of this class are used to encode responses which are returned to
the client from the server.

=head1 METHODS

=head2 $encoder-E<gt>encode( [ $res | $code, $message ] )

Returns the encoded message.  You can pass in either a
L<AnyEvent::FTP::Response> object, or a code message pair.

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
