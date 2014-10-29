package AnyEvent::FTP::Server::Role::Context;

use strict;
use warnings;
use v5.10;
use Moo::Role;
use warnings NONFATAL => 'all';

# ABSTRACT: Server connection context role
our $VERSION = '0.06'; # VERSION

requires 'push_request';

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Server::Role::Context - Server connection context role

=head1 VERSION

version 0.06

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
