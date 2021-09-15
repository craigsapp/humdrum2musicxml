#!/usr/bin/perl
##
## Programmer:    Craig Stuart Sapp <craig@ccrma.stanford.edu>
## Creation Date: Wed 07 Jul 2021 12:45:24 PM PDT
## Last Modified: Wed 07 Jul 2021 12:45:29 PM PDT
## Filename:      /var/www/cgi-bin/humdrum2musicxml.pl
## Syntax:        Perl 5; CGI
## $Smake:        cp -f %f /var/www/cgi-bin/%b
## vim:           ts=3
##
## Description:   Convert Humdrum data into MusicXML files.
##                Backend for https://musicxml.humdrum.org
##                and https://verovio.humdrum.org
##

use strict;
use CGI;
use Digest::MD5 qw(md5 md5_hex md5_base64);
my $cgi_form = new CGI;

# Configuration variables:
my $basedir      = "/project/humdrum2musicxml";
my $cachedir     = "$basedir/cache";
my $maxsize      = 500000;                  # largest file size to allow

# Command-line tools:
my $humdrum2musicxml = "/usr/bin/python3 $basedir/converter21/convertscore.py -t musicxml";
my $cleanMusicxml    = "$basedir/bin/cleanMusicxml";

##########################################################################
##############################                            ###           ##
###############                                            ###############

my %OPTIONS;
my $File = $cgi_form->param('inputdata');
my $inputdata = "";
my $Buffer;
while (read ($File, $Buffer, 1024)) {
	$inputdata .= $Buffer;
}

# print STDERR "INPUT DATA: $inputdata\n";

if ($inputdata =~ /^\s*$/) {
	$inputdata = $File;
	if ($inputdata =~ /^\s*$/) {
		errorMessage("Error: no input score");
	} else {
		convertToMusicxml($inputdata);
	}
} else {
	convertToMusicxml($inputdata);
}

exit(0);

###############                                            ###############
##############################                            ###           ##
##########################################################################

##############################
##
## convertToMusicxml --
##

sub convertToMusicxml {
	my ($inputdata) = @_;

	my $humdrumname = "";
	if ($ENV{'CONTENT_LENGTH'} > $maxsize) {
		errorMessage("Input data is too large");
		return;
	} else {
		$humdrumname = cacheFile($inputdata);
	}
	if ($humdrumname =~ /^\s*$/) {
		errorMessage("Error processing data");
		exit(0);
	}
	my $xmlname = $humdrumname;
	$xmlname =~ s/\.[^.]+$/.xml/;
	if ($xmlname eq $humdrumname) {
		errorMessage("Strange problem with data");
		exit(0);
	}

	#my $command = "$humdrum2musicxml $humdrumname - | $cleanMusicxml > $xmlname";
	my $command = "$humdrum2musicxml $humdrumname - | $cleanMusicxml ";
print STDERR "COMMAND $command\n";
	my $result = `$command`;
	#open (XFILE, $xmlname);
	#my @contents = <XFILE>;
	#close XFILE;
	#my $outputdata = join(@contents);
	my $outputdata = $result;

print STDERR "OUTPUT DATA IS GIVEN AS >>>$outputdata<<<\n";

	if ($outputdata =~ /^<\?mxl/) {
		print "Content-Type: text/x-musicxml\n\n";
		print "$outputdata";
	} else {
		errorMessage($outputdata);
	}
}



##############################
##
## errorMessage --
##

sub errorMessage {
	my ($message) = @_;
	print "Content-Type: text/plain\n\n";
	print "$message\n";
}



##############################
##
## printParameters --
##

sub printParameters {
	my $output = "";
	my $name;
	my $value;
	foreach my $name ($cgi_form->param) {
		foreach my $value ($cgi_form->param($name)) {
			$output .= "$name ==\t$value\n";
		}
	}

	print "Content-Type: text/plain\n\n";
	print "CGI parameters:\n";
	print "$output\n";
}



##############################
##
## cacheFile --
##

sub cacheFile {
	my ($contents, $datatype) = @_;
	my ($year, $month, $day, $hour, $min, $sec) = getDate();
	my $dir = "$cachedir/$year/$month/$day";
	my $filename = "$year$month$day-$hour$min$sec";
	if (-r "$dir/$filename.krn") {
		if (!-r "$dir/$filename-1.krn") {
			$filename .= "-1";
		} elsif (!-r "$dir/$filename-2.krn") {
			$filename .= "-2";
		} elsif (!-r "$dir/$filename-3.krn") {
			$filename .= "-3";
		} elsif (!-r "$dir/$filename-4.krn") {
			$filename .= "-4";
		} elsif (!-r "$dir/$filename-5.krn") {
			$filename .= "-5";
		} elsif (!-r "$dir/$filename-6.krn") {
			$filename .= "-6";
		} elsif (!-r "$dir/$filename-7.krn") {
			$filename .= "-7";
		} elsif (!-r "$dir/$filename-8.krn") {
			$filename .= "-8";
		} elsif (!-r "$dir/$filename-9.krn") {
			$filename .= "-9";
		} elsif (!-r "$dir/$filename-10.krn") {
			$filename .= "-10";
		} elsif (!-r "$dir/$filename-11.krn") {
			$filename .= "-11";
		} elsif (!-r "$dir/$filename-12.krn") {
			$filename .= "-12";
		} elsif (!-r "$dir/$filename-13.krn") {
			$filename .= "-13";
		} elsif (!-r "$dir/$filename-14.krn") {
			$filename .= "-14";
		} elsif (!-r "$dir/$filename-15.krn") {
			$filename .= "-15";
		} elsif (!-r "$dir/$filename-16.krn") {
			$filename .= "-16";
		} elsif (!-r "$dir/$filename-17.krn") {
			$filename .= "-17";
		} elsif (!-r "$dir/$filename-18.krn") {
			$filename .= "-18";
		} elsif (!-r "$dir/$filename-19.krn") {
			$filename .= "-19";
		} elsif (!-r "$dir/$filename-20.krn") {
			$filename .= "-20";
		} elsif (!-r "$dir/$filename-21.krn") {
			$filename .= "-21";
		} elsif (!-r "$dir/$filename-22.krn") {
			$filename .= "-22";
		} elsif (!-r "$dir/$filename-23.krn") {
			$filename .= "-23";
		} elsif (!-r "$dir/$filename-24.krn") {
			$filename .= "-24";
		} elsif (!-r "$dir/$filename-25.krn") {
			$filename .= "-25";
		} elsif (!-r "$dir/$filename-26.krn") {
			$filename .= "-26";
		}
	}
	my $fullfile = "$dir/$filename.krn";
	`mkdir -p $dir`;
	open (FILE, ">$fullfile") or return;
	# my @ekeys = sort keys %ENV;
	my @ekeys = (
		'CONTENT_LENGTH',
		'HTTP_ORIGIN',
		'HTTP_REFERER',
		'HTTP_USER_AGENT',
		'REMOTE_ADDR',
		'UNIQUE_ID'
	);

	print FILE $contents;
	print FILE "\n";
	print FILE "\n";
	print FILE "\n";
	print FILE "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
	print FILE "!!!ID: $filename\n";
	my $md5sum = md5_base64($contents);
	print FILE "!!!MD5SUM: $md5sum\n";
	for (my $i=0; $i<@ekeys; $i++) {
		print FILE "!!!$ekeys[$i]: $ENV{$ekeys[$i]}\n";
	}
	close FILE;

	return $fullfile;
}




##############################
##
## getDate --
##

sub getDate {
	my $cyear;   # current year
	my $cmonth;  # current month
	my $cday;    # current day
	my $chour;   # current hour
	my $cmin;    # current minute
	my $csec;    # current second
	my $weekday; # current weekday
	my $dayofyear;       # current day of year
	my $isdst;   # current timezone

	($csec, $cmin, $chour, $cday, $cmonth, $cyear,
			$weekday, $dayofyear, $isdst) = localtime(time);

	$cmonth += 1;     # fix month so that it is in the range [
	$cyear += 1900;   # fix year so that it is actual year.

	if ($cmonth < 10) {
		$cmonth = int($cmonth);
		$cmonth = "0$cmonth";
	}
	if ($cday < 10) {
		$cday = int($cday);
		$cday = "0$cday";
	}
	if ($chour < 10) {
		$chour = int($chour);
		$chour = "0$chour";
	}
	if ($cmin < 10) {
		$cmin = int($cmin);
		$cmin = "0$cmin";
	}
	if ($csec < 10) {
		$csec = int($csec);
		$csec = "0$csec";
	}

	return ($cyear, $cmonth, $cday, $chour, $cmin, $csec);
	#return "$cyear$cmonth$cday$chour$cmin$csec";
}





