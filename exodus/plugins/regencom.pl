
use strict;
use Cwd;
my $pwd = getcwd;
opendir DIR, $pwd or die "$!";
my @sub = grep -d && ! /^\.+$/ && !/\.svn/, readdir DIR;
my $s;
my $idl;
for $s (@sub) {
    print "$pwd/$s\n";
    chdir "$pwd/$s";
    grep unlink, glob("Exodus_TLB.*");
    e("copy ..\\..\\Exodus_TLB.pas");
}

sub e {
    my $cmd = shift;
    print "$cmd\n";
    system $cmd and exit(1);
}
