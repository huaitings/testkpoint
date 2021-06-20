use strict;
use warnings;
use  Cwd;
my $path = getcwd();
my $kpoint = 25;
my $slurmbatch = "testkpoint.sh";
my $QE_path = "/opt/QEGCC/bin/pw.x";
my @QEinputfile = `cat *.in`;
my @initialkpoint = grep {if(m/(\d+)\s+(\d+)\s+(\d+)\s+\d+\s+\d+\s+\d+\s+/){$_ = "$1 $2 $3";}} @QEinputfile;
for(1..$kpoint){
    `sed 's/@initialkpoint/$_ $_ $_/' espresso.in > $_.in`;
    `mkdir -p $path/kpoint/$_`;
    `mv $_.in $path/kpoint/$_`;
    `sed -e '/#SBATCH.*--job-name/d' $slurmbatch > $_.sh`;
	`sed -i '/#sed_anchor01/a #SBATCH --job-name=k$_' $_.sh`;
   	`sed -i '/#SBATCH.*--output/d' $_.sh`;
	`sed -i '/#sed_anchor01/a #SBATCH --output=$_.out' $_.sh`;
    `sed -i '/mpiexec.*/d'  $_.sh`;
    `sed -i '/#sed_anchor02/a $QE_path -in $_.in' $_.sh`;
    `mv $_.sh $path/kpoint/$_`; 
    chdir("$path/kpoint/$_");	
	system("sbatch $_.sh");
    chdir("$path");
}
sleep(60);
open my $energyraw ,">energy.txt";
for  (1..$kpoint){
chdir("$path/kpoint/$_");	
print $energyraw "$_ ";
my @totalenergy = `cat $_.out | grep !`;
for(0..$#totalenergy){
 if($totalenergy[$_] =~ m/!\s+total\s+energy\s+\=\s+(\-?\d+\.\d+)\s+Ry/g){
   print $energyraw "$1\n";
}
}
chdir("$path/kpoint/");	
}
