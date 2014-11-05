package AnyEvent::FTP::Client::Role::RequestBuffer;

use strict;
use warnings;
use v5.10;
use Moo::Role;
use warnings NONFATAL => 'all';
use AnyEvent;

# ABSTRACT: Request buffer role for asynchronous ftp client
our $VERSION = '0.05'; # VERSION


has request_buffer => (
  is      => 'ro',
  default => sub { [] },
);

sub push_command
{
  my $cv;
  
  $cv = pop if (ref $_[-1]) eq 'AnyEvent::CondVar';
  $cv //= AnyEvent->condvar;

  my($self, @commands) = @_;
  
  push @{ $self->request_buffer }, { cmd => \@commands, cv => $cv };
  
  $self->pop_command;
  
  $cv;
}

sub unshift_command
{
  my $cv;
  
  $cv = pop if (ref $_[-1]) eq 'AnyEvent::CondVar';
  $cv //= AnyEvent->condvar;

  my($self, @commands) = @_;
  
  unshift @{ $self->request_buffer }, { cmd => \@commands, cv => $cv };
  
  $self->pop_command;
  
  $cv;
}

sub pop_command
{
  my($self) = @_;
  
  $self->{ready} //= 1;
  
  return $self unless defined $self->{handle};
  
  unless(@{ $self->request_buffer } > 0)
  {
    $self->{ready} = 1;
    return $self;
  }
  
  return unless $self->{ready};

  my($cmd, $args, $cb) =  @{ shift @{ $self->request_buffer->[0]->{cmd} } };
  my $line = defined $args ? join(' ', $cmd, $args) : $cmd;
  
  my $handler;
  $handler  = sub {
    my $res = shift;
    if(defined $cb)
    {
      my $error = $cb->($res);
      if(defined $error)
      {
        my $batch = shift @{ $self->request_buffer };
        $batch->{cv}->croak($error);
        return;
      }
    }
    if($res->is_preliminary)
    {
      $self->on_next_response($handler);
    }
    else
    {
      $self->{ready} = 1;
      if($res->is_success)
      {
        if(@{ $self->request_buffer->[0]->{cmd} } > 0)
        {
          $self->pop_command;
        }
        else
        {
          my $batch = shift @{ $self->request_buffer };
          $batch->{cv}->send($res);
          $self->pop_command;
        }
      }
      else
      {
        my $batch = shift @{ $self->request_buffer };
        $batch->{cv}->croak($res);
        $self->pop_command;
      }
    }
  };
  
  $self->on_next_response($handler);
  
  $self->{ready} = 0;
  $self->emit('send', $cmd, $args);
  $self->{handle}->push_write("$line\015\012");
  
  $self;
}

sub clear_command
{
  my($self) = @_;
  @{ $self->request_buffer } = ();
  $self->{ready} = 1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AnyEvent::FTP::Client::Role::RequestBuffer - Request buffer role for asynchronous ftp client

=head1 VERSION

version 0.05

=head1 DESCRIPTION

Used internally by L<AnyEvent::FTP::Client>.

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
