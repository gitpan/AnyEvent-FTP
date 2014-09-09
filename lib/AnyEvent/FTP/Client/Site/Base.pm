package AnyEvent::FTP::Client::Site::Base;

use strict;
use warnings;
use v5.10;
use Moo;
use warnings NONFATAL => 'all';

# ABSTRACT: base class for AnyEvent::FTP::Client::Site::* classes
our $VERSION = '0.05'; # VERSION

sub BUILDARGS
{
  my($class, $client) = @_;
  return { client => $client };
}

has client => ( is => 'ro', required => 1 );

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Client::Site::Base - base class for AnyEvent::FTP::Client::Site::* classes

=head1 VERSION

version 0.05

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
