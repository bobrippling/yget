#!/usr/bin/perl

use constant {
	ST_SIZE => 7
};

sub usage
{
	print STDERR "Usage: $0 [link]\n";
	exit 1;
}

sub basename
{
	my $b = shift;
	return $1 if m#/([^/]+$)#;
	return $b;
}

sub bg
{
	my $pid = fork();
	die "fork(): $!\n" unless defined $pid;
	if($pid == 0){
		my $r = system @_;
		die "$_[0] returned $r\n" if $r;
		exit;
	}
}

sub sleep2
{
	select(undef, undef, undef, shift);
}

sub cleanup
{
	$SIG{INT} = undef;

	print STDERR "rm $file? (Y/n) ";

	$_ = <STDIN>;
	exit unless $_;
	chomp;
	if(!length or /^y$/i){
		unlink $file or warn "unlink $file: $!\n";
	}
}

$xsel = 0;
$SIG{INT} = \&cleanup;

for(@ARGV){
	if($_ eq '-x'){
		$xsel = 1;
	}elsif($xsel == 0 && !/^-/){
		usage if $link;
		$link = $_;
	}else{
		push @args, $_;
	}
}

$link = `xsel -o` unless $link;

if($link =~ m#youtu\.be/(.*)#){
	print STDERR "link changed from '$link' to '";
	$link = "http://youtube.com/watch?v=$1";
	print STDERR "$link'\n";
}

chdir '/tmp';

# match either /v/url&x=y... or /?v=url&x=y...
$id = ($link =~ m#v[=/](.{0,11})#)[0];
if(!$id){
	if(length $link == 11){
		$id = $link;
	}else{
		die "no id for $link\n"
	}
}

bg "yget", $id;

my $glob_target = "y*$id.*";

if(-t STDIN){
	$| = 1;
	print STDERR "enter to play\n";
	<STDIN>;
}else{
	print STDERR "no in, waiting for file...\n";
	sleep 1 until glob $glob_target;
	print STDERR "got file, sleeping for 3\n";
	sleep 3;
}

$file = (glob $glob_target)[0];
die "no file ($glob_target)\n" unless $file;
@args = ('mplayer', $file);
system @args;
wait;

cleanup() if -e $file and -t STDIN;
