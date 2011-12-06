#!/usr/bin/perl

#
# Rename WAV tracks by CUE info
# Written by Alexey Semenoff (c) 2008-2009.
# ver 0.2

require 5.008;
use strict;
use Encode;
use Lingua::DetectCharset;

my $sound_basename = 'split-track';
my $sound_ext      = 'wav';

my $cue_file = shift;

if (! $cue_file ) {
    print_usage();
    exit 1;
}

open (CF, "< $cue_file") or die "\nERROR: Cannot open '$cue_file' :$!\n";

while (<CF>)
{
    chomp;
    s/\r//sg;
    next unless /^FILE/i;
    s/^.+?\"(.+?)\".*/$1/i;
    print "\nFound information for file '$_'\n";
    last;
}

my $wait_for_track = 1;
my @tracks = ();

while (<CF>)
{
    chomp;
    s/\r//sg;
    s/^\s+//g;
    s/\s+$//g;
    next unless /^TRACK/i;

    s/^\D+(\d+).*/$1/;
    my $track = $1;

    if ($track != $wait_for_track) {
	print STDERR "\nERROR: wrong CUE file, waiting for track '$wait_for_track', got '$track'\n";
	close CF;
	exit 1;
    }
    $wait_for_track++;

    while (<CF>) {
	chomp;
	s/\r//sg;
	s/^\s+//g;
	s/\s+$//g;

	if (/TRACK/i) {
	    print STDERR "\nERROR: no title for track '$track'\n";
	    	close CF;
	    exit 1;
	}

	if (/TITLE/) {
	    s/^.+?\"(.+?)\".*/$1/i;
	    my $title = normalize_name ( $track . '_' . $_ );
	    print "   Track $track -> '$title'\n";
	    push @tracks, $title;
	    last;
	}
    }
}

close CF;

my @files = sort { $a <=> $b } glob ("$sound_basename*$sound_ext");

die "No $sound_ext files found in current directory\n" unless @files;

if (scalar (@files) != scalar (@tracks) )
{
    print STDERR "\nERROR: Files/tracks mismatch, files: ", scalar(@files), ' tracks: ', scalar(@tracks), "\n";
    die "\n";
}

print "\nRenaming ...\n";

for (my $i=0; $i < scalar(@files); $i++)
{
    my $from_file = $files[$i];
    my $to_file   = $tracks[$i] . '.' . $sound_ext;

    print "   $from_file --> $to_file\n";
    rename ($from_file, $to_file);
    
    unless (-f $to_file) {
	print STDERR "\tWARN: cannot remove file: $!\n\n";
    } 

} 

print "\n*** Done! ***\n";
exit 0;

sub print_usage
{
    print <<EOS;
Usage: $0 file.cue
EOS

}

sub normalize_name
{
    $_ = $_[0];

    my $charset = Lingua::DetectCharset::Detect ($_);

    my $decode_from = q{};
    if ($charset eq 'WIN') {
	$decode_from = "CP-1251";
    }
    elsif ($charset eq 'UTF8') {
	$decode_from = "utf8";
    }else {} 

# convert whatever -> koi8-r     
    Encode::from_to ($_, "$decode_from", "KOI8-R") if $decode_from;
    
# convert cyrillic -> latin , replace spaces, {}[]() etc...
    tr|ÁÂ×ÇÄÅ£ÚÉÊËÌÍÎÏÐÒÓÔÕÆÈÙÜØßáâ÷çäå³úéêëìíîïðòóôõæèùüøÿ|abvgdeezijklmnoprstufhye  ABVGDEEZIJKLMNOPRSTUFHYE  |;
    s/À/ju/g;
    s/à/Ju/g;
    s/Ã/ts/g;
    s/ã/Ts/g;
    s/Ö/zh/g;
    s/ö/Zh/g;
    s/Ñ/ya/g;
    s/ñ/Ya/g;
    s/À/yu/g;
    s/à/Yu/g;
    s/Û/sh/g;
    s/û/Sh/g;
    s/Ý/shch/g;
    s/ý/Shch/g;
    s/Þ/ch/g;
    s/þ/Ch/g;
    s|\(| |g;
    s|\)| |g;
    s|\[| |g;
    s|\]| |g;
    s|\{| |g;
    s|\}| |g;
    s|\\| |g;
    s|\/| |g;
    s|:| |g;
    s|\x84|e|isg;
    s|\x84|e|isg;
    s/_\-_/_/;
    s/ /_/g;
    s/_\-_/_/;
    s/_$//;


    s|'|_|g;
    s|`|_|g;
    s|\s|_|g; s|\(|_|g; s|\)|_|g;
    s|&||g;
    s|,|_|g;
    s|\%20|_|g;

    s|_\-_|__|g;
    s|_+\.|.|;
    s|\?|_|isg;
    s|\:|_|g;
    s|\[|_|g;
    s|\]|_|g;
    s|\!|_|g;
    s|\&|_|g;
    s|_$||;
    s|\.|_|g;
    s|_(_)+|_|g;
    $_;
}


__END__
