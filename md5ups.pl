#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Digest::MD5 qw(md5_hex);   
use 5.010;

use constant false => 0;	#定义false,true;
use constant true  => 1;
#for md5+salt brute force

my $passwordfile;
my $plain_text;        #single password in passwordfile
my $cipher_text;
my $salt;
my $username;
my $help;
my $version;
my $check_password;
my $flag=0;

##	@author by conan
##	@qq 2441456964


#定义参数列表
GetOptions(
	'h|help!' => \$help,
	'v|version!' => \$version,
	'p=s' => \$passwordfile,
	'c=s' => \$cipher_text,
	's=s' => \$salt,
	'u=s' => \$username,
);

#some definition for options

sub help{
say "用于爆破若依cms账号密码[MD5(username+password+salt)]";
say "useage:	perl filename.pl -p passwordfile -c cipher_text -s salt -u username [-h|-v]";
say "example:   perl md5ups.pl -p pass.txt -c d6ddbdeba60446cd1a732e8148eba29c -s 111 -u admin";
say "-h|-help	get for	some help";
say "-v|version get version";
say "-p        \$passwordfile(file path for passwords";
say "-c		   \$cipher_text (md5(username+pass+salt)),complex pass";
say "-s		   \$salt(the salt value for pass";
say "-u		   \$username(the username value for pass";
}

say "Version 1.05(just for  multiple parameters -p -c -s -u)" if (defined $version);
&help if(defined $help);

if(defined $passwordfile&&defined $cipher_text&&defined $salt&&defined $username){
	&result;
}
else{
	&help;
}

sub result{
	sub check_password{
		my $now_plain_text=$_[0];   #接收$plain_text 参数
		$check_password=md5_hex($username.$now_plain_text.$salt);
		if($cipher_text ne $check_password){
			return 0;
		}
		else{
			return 1;
		}
	}

	open (FILE ,$passwordfile) or die "can't open the file $!";
	while(<FILE>){
		chomp;
		$_ =~ s/^\s+|\s+$//g;
		$plain_text=$_;
		if(&check_password($plain_text)){
			$flag=1;
			say "爆破成功，密码： $plain_text";
			last;
		}
	}

	if ($flag==0) {
		say "sorry , can't find the password!";
	}
	close(FILE);

}

__END__

