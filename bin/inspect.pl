#!/usr/bin/perl -w

# Copyright  (c)  2015-2017  T.v.Dein <tlinden  |AT|  cpan.org>.   All
# Rights Reserved. Std. disclaimer applies.  Artistic License, same as
# perl itself. Have fun.

# This  script  can   be  used  to  interactively   browse  perl  data
# structures, which it reads from STDIN or a file. You can use it, for
# instance, by printing some data  structure in your application using
# Data::Dumper and piping this output into this scripts input.

# If the data structure evaulates, you'll be dropped into an interactive
# prompt. Enter '?' to get help.

# The script also demonstrates how to use different serializers.

use Data::Interactive::Inspect;
use Data::Dumper;
use strict;

sub usage {
  print STDERR qq(
Usage: $0 <file|-h>

Reads a  perl data structure  from <file>. If  <file> is -,  read from
STDIN. Evaluates  and start an  interactive Data::Interactive::Inspect
shell, which can be used to analyze the data.
);
  exit 1;
}


my $arg = shift;
my $code;

if (! $arg) {
  usage;
}

if ($arg ne '-' && ! -e $arg) {
  print STDERR "$arg not found or not readable!\n";
  usage;
}

if ($arg eq '-') {
  $code = join '', <>;
}
else {
  open CODE, "<$arg" or die "Could not open data file $arg: $!\n";
  $code = join '', <CODE>;
  close CODE;
}

# var name? throw away
$code =~ s/^\s*\$[a-zA-Z0-9_]*\s*=\s*/\$code = /;
eval $code;

if ($@) {
  print STDERR "Parser or Eval error: $@!\n";
  exit 1;
}
else {
  Data::Interactive::Inspect->new(struct      => $code,
                                  serialize   => sub { my $db = shift;
                                                       my $c = Dumper($db);
                                                       $c =~ s/^\s*\$[a-zA-Z0-9_]*\s*=\s*/        /;
                                                       return $c;
                                                     },
                                  deserialze  => sub { my $code = shift;
                                                       $code = "\$code = $code";
                                                       eval $code;
                                                       return $code;
                                                     },
                                 )->inspect;
}











