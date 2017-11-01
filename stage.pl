#!/bin/perl -w

use strict;
# publish server
$::USER = 'peter';
$::SERVER = '192.168.1.1';
$::ROOT = '/home/httpd/html/stage';

$::SCP = 'pscp ';
$::SSH = 'plink ';
$::CVS = 'cvs';

$::RTYPE = "stage";
$::VTYPE = "build";

my $userhost = $::USER ? "$::USER\@$::SERVER" : $::SERVER;

print "$::RTYPE build (version $::VTYPE)...\n";

chdir "exodus" or die;

my $version = `cat version`;
chomp $version;

print "$version\n";
chdir ".." or die;

my $urtype = uc($::RTYPE);
e("perl build.pl $::RTYPE");
e("$::CVS ci -m \"$::RTYPE build\" exodus/version.h exodus/version.nsi exodus/default.po") if $::CVS;

chdir "exodus" or die;
  my $uver;
  ($uver = $version) =~ s/\./_/g;
  e("$::SCP setup.exe $userhost:$::ROOT");
  e("$::SCP plugins/*.zip $userhost:$::ROOT/plugins");
  e("$::SSH $userhost \"chmod 664 $::ROOT/setup.exe $::ROOT/plugins/*.zip\"");

print "\n\nSUCCESS!\n";

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}
