#!/usr/bin/perl


use warnings;
use strict;
use Data::Dumper;
use JSON;
use LWP::UserAgent;
use LWP::Simple qw(getstore);
use File::Slurp;
use Encode;

my $configfile = "./config.json";
my $configdata = decode_json Encode::encode 'utf8', read_file $configfile, { binmode => ':utf8' } ;

my $ua = LWP::UserAgent->new();
my $urllist = $configdata->{'host'}."/list/index.html";
my $response = $ua->get($urllist);
die $response->status_line if !$response->is_success;
my $file = $response->decoded_content( charset => 'none' );

my $savelist = $configdata->{'cache-path'}."/list";
getstore($urllist,$savelist);

my $integer = 0;
while (42) {

    my $entity_file = $configdata->{'host'}."/file/".$integer;
    my $response = $ua->get($entity_file);
    die "The cycle has been stopped. Probably an all files was downloaded." if !$response->is_success;

    my $savefile = $configdata->{'cache-path'}."/file/".$integer;
    getstore($entity_file,$savefile);

    $integer += 1;
    print($entity_file."\n");
}
