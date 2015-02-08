#!/usr/bin/perl

use lib qw (blib/lib);
use Data::Interactive::Inspect;
use Data::Dumper;
my $s = {
	 h => [1,2,3,4,5],
	 users => [
		   { login => 'max', age => 12 },
		   { login => 'leo', age => 23 },
		  ],
	 any   => {
		    fear => {
			      settings => {
					   height => 89,
					   mode => 'normal',
					   looks => [ 3,5,6],
					   }
			     },
		  }
	 };

my $shell = Data::Interactive::Inspect->new($s);
my $x = $shell->inspect();
#print Dumper($x);
