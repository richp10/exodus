#!/bin/perl -w

use strict;

# Put these options into dopts.pl to save personal settings
$::rtype = "release";
$::D = 'f:/lang/Delphi7';
$::TNT = "D:\\src\\exodus\\exodus\\components\\tntUnicode";
$::ICQ = "D:\\src\\exodus\\exodus\\plugins\\ICQ-Import\\ICQ\\Component";
$::JCL = "D:\\src\\jcl";
$::NSIS = "\"D:\\Program Files\\NSIS\\makensis.exe\"";
$::DXGETDIR = "F:\\lang\\dxgettext";

do "dopts.pl";

$::MSGFMT = "$::DXGETDIR\\msgfmt.exe";
$::DXGETTEXT = "$::DXGETDIR\\dxgettext.exe";

my $DD;
($DD = $::D) =~ s/\//\\/g;
my $imports = "\"$DD\\Imports\"";
my $dcc = "\"$::D\\Bin\\dcc32.exe\"";
my $rcc = "\"$::D/Bin/brcc32.exe\"";
my $jclopts = "-I\"$::JCL\" -U\"$::JCL\" -U\"$::JCL\\common\" -U\"$::JCL\\vcl\" -U\"$::JCL\\windows\"";
my $opts = "-LUvcl -LUrtl -DIndy9 -B -Q -U\"$DD\\Lib\" -U\"$DD\\Lib\\Indy9\" -U\"..\\jopl\\TNGImage\\Package\" $jclopts";
my $comp = "..\\..\\Components";
my $plugopts = "$opts -U\"..\\..\" -U.. -U\"..\\..\\..\\jopl\" -U\"$comp\" -U\"$comp\\base\" -U\"$::TNT\"";
my $installer = "1";

if ($#ARGV >= 0) {
  if ($ARGV[0] eq "daily") {
	$::rtype = "daily";
  } elsif ($ARGV[0] eq "compile") {
    $::rtype = "daily";
    $installer = "0";
  } elsif ($ARGV[0] eq "stage") {
    $::rtype = "stage";
  } elsif ($ARGV[0] eq "help") {
	print <<EOF;
USAGE:
build.pl [daily|stage]
   defaults to release.
EOF
	exit(64);
  }
}

chdir "exodus" or die;

unlink "setup.exe";
unlink "Exodus.exe";
grep unlink, glob("output/*.dcu"); # rm *.dcu
grep unlink, glob("*_emoticons.dll"); # rm *.dll
grep unlink, glob("IdlHooks.dll");

e("$dcc $opts -Noutput IdleHooks.dpr");
e("$rcc version.rc");
e("$rcc xml.rc");
e("$rcc iehtml.rc");

if ($::rtype eq "daily") {
    # Generate a detailed MAP file, and build in stack frame tracing
    e("$dcc $opts -DExodus -GD -DTRACE_EXCEPTIONS -Noutput -U\"Components\" -U\"$::TNT\" Exodus.dpr");
} else {
    e("$dcc $opts -DExodus -DTRACE_EXCEPTIONS -D -Noutput -U\"Components\" -U\"$::TNT\" Exodus.dpr");
}

e("$::DXGETTEXT *.pas *.inc *.dpr *.xfm *.dfm prefs\\*.pas prefs\\*.inc prefs\\*.rc prefs\\*.dpr prefs\\*.xfm prefs\\*.dfm ..\\jopl\\*.pas ..\\jopl\\*.inc ..\\jopl\\*.rc ..\\jopl\\*.dpr ..\\jopl\\*.xfm ..\\jopl\\*.dfm");

unlink "locale.zip";
grep unlink, glob("locale/*/LC_MESSAGES/default.mo");
grep &msgfmt, glob("locale/*/LC_MESSAGES/default.po");
e('zip locale ' . join(' ', glob("locale/*/LC_MESSAGES/default.mo")));

chdir "msn-emoticons";
e("$rcc msn.rc");
e("$dcc $opts -D msn_emoticons.dpr");
chdir "../yahoo-emoticons";
e("$rcc yahoo.rc");
e("$dcc $opts -D yahoo_emoticons.dpr");

# go into our plugins dir and process
chdir "../plugins";
grep unlink, glob("*.zip"); # rm *.zip
grep unlink, glob("*.dll"); # rm *.dll

# Always build the HTML Logger plugin
chdir "HTMLLogger";
e("$dcc $plugopts -U$imports -E.. -N.\\\\output ExHTMLLogger.dpr");
chdir ".." ;

open SEC,">plugin-sections-new.nsi" or die $!;
open DESC,">plugin-desc-new.nsi" or die $!;
open I18N,">plugin-i18n-new.nsh" or die $!;

# for each non-CVS directory
my $f;
for (glob("*")) {
  next unless -d;
  next if /^CVS$/;
  print "$_\n";
  plug($_);
}

close SEC;
close DESC;
close I18N;

chdir "..";

# Create the Exodus.zip file
unlink "Exodus.zip";
e('zip Exodus.zip @zipfiles.txt ' . join(' ', glob("plugins/*.dll")));

# Build the installer
if ($installer eq "0") { 
    # do nothing in this case
} elsif ($::rtype eq "daily") {
  e("$::NSIS /v1 /DDAILY exodus-new.nsi");
} elsif ($::rtype eq "stage") {
  e("$::NSIS /v1 /DSTAGE exodus-new.nsi");
} else {
  e("$::NSIS /v1 exodus-new.nsi");
  e("$::NSIS /v1 /DNO_NETWORK exodus-new.nsi");
}

print "SUCCESS!!!\n";
chdir ".." or die;

### DONE

sub e {
  my $cmd = shift;
  print "$cmd\n";
  system $cmd and exit;
}

sub plug {
  my $p = shift;
  chdir $p or die;

  my $dpr = (glob("*.dpr"))[0];
  unless ($dpr) { chdir ".."; return };
  unless (-e("plugin-info.nsh")) { chdir ".."; return };

#  grep unlink, glob("ExodusCOM_TLB.*");
#  e("copy ..\\..\\ExodusCOM_TLB.pas");

  my $thisopts = $plugopts;
  if ($p =~ /ICQ/) { $thisopts .= " -U$::ICQ"; }

  (my $base = $dpr) =~ s/\.dpr$//;
  (my $bare = $base) =~ s/^Ex//;

  e("$dcc $thisopts -U$imports -E.. -N.\\\\output $dpr");

  my $size = -s("../$base.dll");
  $size = int $size / 1024;
  print SEC <<"EOF";
	Section /o "$bare" SEC_$base
	  AddSize $size
	  Push "$base"
	  Call DownloadPlugin
      RegDll "\$INSTDIR\\plugins\\$base.dll"
	SectionEnd

EOF

  print DESC <<"EOF";
  !insertmacro MUI_DESCRIPTION_TEXT \${SEC_$base} \$(DESC_$base)
EOF

  print I18N <<"EOF";
!include "$p\\plugin-info.nsh"
EOF

  chdir "..";
  e("zip $base.zip $base.dll");
}

sub msgfmt() {
  my $po = $_;
  (my $mo = $po) =~ s/po$/mo/;

  e("$::MSGFMT $po -o $mo");
}
