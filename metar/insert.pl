#!/usr/bin/perl

use Geo::METAR;
use DBI;
use Scalar::Util qw/looks_like_number/;

$DBUSER='hirez';
$DBPASSWD='passwd';
$DBNAME='metar';
$DBIOPT="dbi:Pg:dbname=$DBNAME;host=localhost";

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(time);
$year += 1900;
$mon += 1;

sub getTimestamp
{
	my $m = @_[0];
	my $month = $mon;
	my $time;

	if($mday - $m->DATE <= -27){
		$month -= 1;
	}if(($mday - $m->DATE) >= 27){
		$month += 1;
	}
	$time = (split(/ /, $m->TIME))[0]; 
	return sprintf "%4d/%02d/%02d %s:00", $year, $month, $m->DATE, $time;
}


sub val
{
	return undef if !looks_like_number(@_[0]);
	return @_[0];
}
		
sub execute
{
	my $m = new Geo::METAR;
	my $sth = @_[1];
	$m->metar(@_[0]);

	my $wind_deg = val($m->WIND_DIR_DEG);
	my $wind_kts = val($m->WIND_KTS);
	my $temp = val($m->TEMP_C);
	my $dew = val($m->C_DEW);
	my $alt = val($m->ALT_HP);

	$sth->execute($m->SITE, getTimestamp($m), $wind_deg, $wind_kts, $temp, $dew, $alt, $m->METAR);
}

sub main
{
	my $dbh = DBI->connect($DBIOPT, $DBUSER, $DBPASSWD,
		{
			PrintError =>0
		}) or die;
	my $sth = $dbh->prepare("SELECT addReport(?,?,?,?,?,?,?,?);");
	my @input = <STDIN>;
	foreach my $line (@input){
		if( $line =~ /^[A-Z]/){
			execute $line, $sth
		}
	}
	$sth->finish;
	$dbh->disconnect;
}


&main

