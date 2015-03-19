#!/usr/bin/perl

use warnings;
use strict;
use Irssi;
use Irssi::Irc;

use vars qw($VERSION %IRSSI);

$VERSION = "1.0.0";
%IRSSI = (
	"authors"       => "Troy Ablan",
	"contact"       => "tablan+irssi\@gmail.com",
	"name"          => "braillesay",
	"description"   => "Dot-matrix UTF-8 art, using the Braille codepoints. Available commands: /BRSAY",
	"license"       => "GNU GPL v2 or Perl Artistic",
);


my $cp;

for my $a (0..7,64..71) {
	my @row;
	for my $b (0,8,16,24,32,40,48,56,128,136,144,152,160,168,176,184) {
		push @row, chr(10240+$a+$b);
	}
	push @$cp, \@row;
}

my $chars = {
	'A' => 'e5e0',
	'B' => 'ff60',
	'C' => '6990',
	'D' => 'f960',
	'E' => 'fbb0',
	'F' => 'f550',
	'G' => '69d0',
	'H' => 'f2f0',
	'I' => '9f90',
	'J' => '4870',
	'K' => 'f2d0',
	'L' => 'f880',
	'M' => 'f242f0',
	'N' => 'f24f0',
	'O' => '69960',
	'P' => 'f520',
	'Q' => '699e0',
	'R' => 'f5a0',
	'S' => 'abd50',
	'T' => '1f10',
	'U' => 'f8f0',
	'V' => '7870',
	'W' => '787870',
	'X' => '9690',
	'Y' => '3c30',
	'Z' => '9db90',
	' ' => '000',
	'-' => '2220',
	'_' => '8880',
	"'" => '030',
	'"' => '03030',
	'\\' => '12480',
	'/' => '84210',
	'=' => 'aaa0',
	'^' => '2120',
	'+' => '2720',
	'*' => '96f690',
	':' => 'a0',
	';' => '8a0',
	'.' => '80',
	',' => '840',
	'|' => 'f0',
	'[' => 'f90',
	']' => '9f0',
	'{' => '6f90',
	'}' => '9f60',
	'<' => '4a0',
	'>' => 'a40',
	'(' => '690',
	')' => '960',
	'!' => 'b0',
	'?' => '2930',
	'@' => '6ffe80',
	'#' => 'afafa0',
	'$' => '46f620',
	'$' => 'af0f50',
	'%' => '94290',
	'&' => 'cff840',
	'0' => '6db60',
	'1' => 'af80',
	'2' => 'adb90',
	'3' => '9bbf0',
	'4' => '322f0',
	'5' => 'bbd50',
	'6' => '6dd0',
	'7' => '95310',
	'8' => 'cffc0',
	'9' => 'bb60',
};

sub text2braille {
	my $text = shift;
	my $invert = shift;

	my $hexstring = "";

	$hexstring .= "f" if ($invert);

	for my $letter (split (//,$text)) {
		if (my $hl = $chars->{uc($letter)}) {
			$hl = invert($hl) if ($invert);
			$hexstring .= $hl;
		}
	}

	$hexstring .= "f" if ($invert);

	$hexstring .= "0" unless (length($hexstring)/2 == int(length($hexstring)/2));

	my $returnstring = "";

	while ($hexstring =~ /(.)(.)(.*)/) {
		$returnstring .= $cp->[hex($1)][hex($2)];
		$hexstring = $3;
	}

	return $returnstring;
}

sub invert {
	my $string = shift;

	my $returnstring = "";
	for my $l (split (//,$string)) {
		$returnstring .= sprintf("%x",15-hex($l));
	}
	return $returnstring;
}	

sub cmd_brsay {
	my ($arguments, $server, $witem) = @_;

	my $window = Irssi::active_win();
	$window->command("/say ".text2braille($arguments));
}

Irssi::command_bind('brsay', 'cmd_brsay');
