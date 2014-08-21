package AnyEvent::FTP::Client::Site;

use strict;
use warnings;
use v5.10;

# ABSTRACT: Dispatcher for site specific ftp commands
our $VERSION = '0.04_01'; # VERSION

sub new
{
  my($class, $client) = @_;
  bless { client => $client }, $class;
}

sub AUTOLOAD
{
  our $AUTOLOAD;
  my $self = shift;
  my $name = $AUTOLOAD;
  $name =~ s/^.*://;
  $name =~ s/_(.)/uc $1/eg;
  my $class = join('::', qw( AnyEvent FTP Client Site ), ucfirst($name) );
  eval qq{ use $class () };
  die $@ if $@;
  $class->new($self->{client});
}

# don't autoload DESTROY
sub DESTROY { }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Client::Site - Dispatcher for site specific ftp commands

=head1 VERSION

version 0.04_01

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
