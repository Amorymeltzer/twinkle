#!/usr/bin/env perl
# sync.pl by azatoth (2011), update by amorymeltzer (2019)

use strict;
use warnings;
use diagnostics;

use English qw( -no_match_vars);
use Encode;
use utf8;

use Git::Repository;
use MediaWiki::API;
use File::Slurp;
use Config::General qw(ParseConfig);
use Getopt::Long::Descriptive;

# Config file should be a simple file consisting of keys and values:
# username = Jimbo Wales
# lang = en
# etc.
my $config_file = "$ENV{HOME}/.twinklerc";
my %conf = ParseConfig($config_file);

use Data::Dumper;
print Dumper(\%conf);

my ($opt, $usage) = describe_options(
    "$PROGRAM_NAME %o <files...>",
    ['username|u=s', 'username for account on wikipedia', {default => $conf{username} // q{}}],
    ['password|p=s', 'password for account on wikipedia (do not use)', {default => $conf{password} // q{}}],
    ['base|b=s', 'base location on wikipedia where files exist (default User:AzaToth or entry in .twinklerc)', {default => $conf{base} // 'User:AzaToth'}],
    ['lang=s', 'Target language', {default => 'test'}],
    ['family=s', 'Target family', {default => 'wikipedia'}],
    ['mode' => hidden =>
        {
            required => 1,
            one_of => [
                ['deploy' => 'push all files'],
                ['push' => 'push selected files']
            ]
        }
    ],
    [],
    ['help', 'print usage message and exit'],
);
print "\nOPTIONS\n";
print Dumper($opt);

if ($opt->help || !scalar @ARGV) {
  print $usage->text;
  exit;
}

my @pages;
my %deploys = (
	'twinkle.js' => 'MediaWiki:Gadget-Twinkle.js',
	'twinkle.css' => 'MediaWiki:Gadget-Twinkle.css',
	'twinkle-pagestyles.css' => 'MediaWiki:Gadget-Twinkle-pagestyles.css',
	'morebits.js' => 'MediaWiki:Gadget-morebits.js',
	'morebits.css' => 'MediaWiki:Gadget-morebits.css',
	'modules/friendlyshared.js' => 'MediaWiki:Gadget-friendlyshared.js',
	'modules/friendlytag.js' => 'MediaWiki:Gadget-friendlytag.js',
	'modules/friendlytalkback.js' => 'MediaWiki:Gadget-friendlytalkback.js',
	'modules/friendlywelcome.js' => 'MediaWiki:Gadget-friendlywelcome.js',
	'modules/twinklearv.js' => 'MediaWiki:Gadget-twinklearv.js',
	'modules/twinklebatchdelete.js' => 'MediaWiki:Gadget-twinklebatchdelete.js',
	'modules/twinklebatchprotect.js' => 'MediaWiki:Gadget-twinklebatchprotect.js',
	'modules/twinklebatchundelete.js' => 'MediaWiki:Gadget-twinklebatchundelete.js',
	'modules/twinkleblock.js' => 'MediaWiki:Gadget-twinkleblock.js',
	'modules/twinkleconfig.js' => 'MediaWiki:Gadget-twinkleconfig.js',
	'modules/twinkledeprod.js' => 'MediaWiki:Gadget-twinkledeprod.js',
	'modules/twinklediff.js' => 'MediaWiki:Gadget-twinklediff.js',
	'modules/twinklefluff.js' => 'MediaWiki:Gadget-twinklefluff.js',
	'modules/twinkleimage.js' => 'MediaWiki:Gadget-twinkleimage.js',
	'modules/twinkleprotect.js' => 'MediaWiki:Gadget-twinkleprotect.js',
	'modules/twinklespeedy.js' => 'MediaWiki:Gadget-twinklespeedy.js',
	'modules/twinkleunlink.js' => 'MediaWiki:Gadget-twinkleunlink.js',
	'modules/twinklewarn.js' => 'MediaWiki:Gadget-twinklewarn.js',
	'modules/twinklexfd.js' => 'MediaWiki:Gadget-twinklexfd.js',
	'modules/twinkleprod.js' => 'MediaWiki:Gadget-twinkleprod.js'
);

my $repo = Git::Repository->new();
# Ensure we've got a working/clean master branch
my $status = $repo->run('status');
if ($status !~ /On branch master/ || $status !~ /nothing to commit, working tree clean/) {
  print "Not on branch 'master' or repository is not clean, aborting...\n";
  exit 1;
}

my $mw = MediaWiki::API->new({
			      api_url => "https://$opt->{lang}.$opt->{family}.org/w/api.php",
			      max_lag => 1000000 # not a botty script, thus smash it!
			     });
$mw->login({lgname => $opt->username, lgpassword => $opt->password})
  or die $mw->{error}->{code} . ': ' . $mw->{error}->{details};

if ($opt->mode eq 'deploy') {
  @pages = keys %deploys;
} elsif ($opt->mode eq 'push') {
  @pages = @ARGV;
}
foreach my $file (@pages) {
  if (!defined $deploys{$file}) {
    print "$file not deployable\n";
    exit 1;
  }
  my $page = $deploys{$file};
  print "$file -> $opt->{lang}.$opt->{family}.org/wiki/$page\n";
  my $text = read_file($file,  {binmode => ':raw' });
  my $summary = buildEditSummary($file, $page);
  my $editReturn = editPage($page, decode('UTF-8', $text), $summary);
  if ($editReturn->{_msg} eq 'OK') {
    print "$file successfully pushed to $page\n";
  } else {
    print "Error pushing $file: $mw->{error}->{code}: $mw->{error}->{details}\n";
  }
}


### SUBROUTINES
sub buildEditSummary {
  my ($file, $page) = @_;

  # Find the last edit summary used onwiki, use it to get the changes since then
  my $ref = $mw->api({
		      action => 'query',
		      format => 'json',
		      prop => 'revisions',
		      titles => $page,
		      formatversion => '2',
		      rvprop => 'comment',
		      rvlimit => '1'
		     }) || die "Error querying $page: $mw->{error}->{code}: $mw->{error}->{details}";
  # my $oldCommitish = @{@{$ref->{query}->{pages}}[0]->{revisions}}[0]->{comment};
  my $oldCommitish = $ref->{query}->{pages};
  $oldCommitish = @{$oldCommitish}[0]->{revisions};
  $oldCommitish = @{$oldCommitish}[0]->{comment};

  my $editSummary = 'Repo at ';
  $editSummary .= $repo->run('rev-parse' => '--short', 'HEAD');
  $editSummary .= q{:};

  print "oldcomit\t$oldCommitish\n";

  # User:Amorymeltzer & User:MusikAnimal or User:Amalthea
  if ($oldCommitish =~ /(?:Repo|v2\.0) at (\w*?): / || $oldCommitish =~ /v2\.0-\d+-g(\w*?): /) {
    my $newLog = $repo->run(log => '--oneline', '--no-color', "$1..HEAD", 'modules/twinklexfd.js');
    open my $nl, '<', \$newLog or die $ERRNO;
    while (<$nl>) {
      chomp;
      my @arr = split / /, $_, 2;
      next if $arr[1] =~ /Merge pull request #\d+/;

      if ($arr[1] =~ /(\w+(?:\.(?:js|css))?) ?[:|-] (.*)/) {
	$editSummary =~ s/\.$//; # Just in case
	$editSummary .= " $2;";
      }
    }
    close $nl or die $ERRNO;

    $editSummary =~ s/\;$//;
  } else {
    print "Error generating edit summary for $file, please enter one now\n";
    $editSummary = <STDIN>;
    chomp $editSummary;
  }
  return $editSummary;
}

sub editPage {
  my ($pTitle, $nText, $pSummary) = @_;
  my $ref = $mw->get_page( { title => $pTitle } );
  if (defined $ref->{missing}) {
    print "$pTitle does not exist\n";
    exit 1;
  } else {
    my $timestamp = $ref->{basetimestamp};
    $mw->edit({
	       action => 'edit',
	       title => $pTitle,
	       basetimestamp => $timestamp, # Avoid edit conflicts
	       text => $nText,
	       summary => $pSummary
	      }) || die $mw->{error}->{code} . ': ' . $mw->{error}->{details};
  }
  return $mw->{response};
}
