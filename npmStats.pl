#!/usr/bin/env perl
# npmStats.pl by Amory Meltzer
# Bulk calculate linting errors per option

use strict;
use warnings;
use diagnostics;

use FindBin;

my $scriptDir = $FindBin::Bin;	# Directory of this script
my $outfile = 'lint.md';
my @lints;			# To access hash keys as well as get a count
my %results;

while (<DATA>) {
  chomp;
  push @lints, $_;

  my $es = `$scriptDir/npmStats.sh '$_'`;
  my $err = $?;			# Return error from eslint: 2 if eslint fails
                                # (typo in "error") but 1 if successfully
                                # finds errors or if there's a typo in the key
                                # ("no-spacess").  0 if no (lint) errors

  if ($err == 512) {		# 2 (2*2^8)
    print "Error processing $_\n";
    next;
  } else {
    my ($opt,$config) = /(.*?): (.*)/;
    if ($es =~ /error  Definition for rule .* was not found/) { # Typo in key
      print "Error processing $_\n";
      next;
    }
    $opt =~ s/"(.*)"/[$1](https:\/\/eslint.org\/docs\/rules\/$1)/;
    my ($probs,$fixes) = (0,0);
    if ($err == 256 && $es) {	# 1 (1*2^8)
      $probs = $1 if $es =~ /(\d+) problems/;
      if ($es =~ /(\d+) errors and (\d+) warnings potentially/) {
	$fixes = $1+$2;
      }

      if ($fixes > 0 && $fixes == $probs) {
	$fixes = 'Yes';
      } elsif ($fixes > 0 && $fixes != $probs) {
	$fixes = 'Yes ('.$fixes.')';
      } else {
	$fixes = 'No';
      }
    } else {
      $fixes = q{?};
    }

    print scalar @lints;
    print "\n";
    $results{$_} = "| ❌✔️  | $opt | $config | $probs | $fixes |  | |";

  }
}

my $header;
$header  = "| Included?   | Option      | Config      | Curr errors | Fixable?    | Category    | Notes?      |\n";
$header .= "| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |\n";

open my $out, '>', "$outfile" or die $1;
print $out $header;
foreach (@lints) {
  if ($results{$_}) {
    print $out "$results{$_}\n";
  }
}
close $out or die $1;

my $lintsC = scalar @lints;
my $resultsC = scalar keys %results;
print "$lintsC items attempted, $resultsC actually processed\n";


## The lines below do not represent Perl code, and are not examined by the
## compiler.  Rather, they are a list of possible linting option.
__END__
"no-extra-parens": "error"
  "no-extra-parens": ["error", "all", { "nestedBinaryExpressions": false }]
  "no-extra-parens": ["error", "functions"]
  "curly": "error"
  "curly": ["error", "multi"]
  "curly": ["error", "multi-line"]
  "no-multi-spaces": ["error", { "ignoreEOLComments": true }]
  "no-multi-spaces": ["error"]
  "guard-for-in": "error"
  "block-scoped-var": "error"
  "eqeqeq": "error"
  "eqeqeq": ["error", "smart"]
  "no-else-return": "error"
  "no-implicit-coercion": ["error", { "boolean": false }]
  "no-implicit-coercion": ["error"]
  "no-useless-catch": "error"
  "no-useless-return": "error"
  "yoda": "error"
  "no-prototype-builtins": "error"
  "default-case": "error"
  "no-empty-function": "error"
  "no-eq-null": "error"
  "no-lone-blocks": "error"
  "no-script-url": "error"
  "no-undefined": "error"
  "no-global-assign": "error"
  "no-shadow-restricted-names": "error"
  "linebreak-style": ["error", "unix"]
  "array-bracket-spacing": ["error", "never"]
  "block-spacing": "error"
  "brace-style": ["error", "1tbs", { "allowSingleLine": true }]
  "brace-style": ["error", "1tbs"]
  "comma-dangle": "error"
  "comma-spacing": ["error", { "before": false, "after": true }]
  "key-spacing": ["error", {"singleLine": {"beforeColon": false, "afterColon": true}}]
  "key-spacing": ["error", {"singleLine": {"beforeColon": true, "afterColon": true}}]
  "key-spacing": ["error", {"singleLine": {"beforeColon": false, "afterColon": false}}]
  "key-spacing": ["error", {"singleLine": {"beforeColon": true, "afterColon": false}}]
  "no-bitwise": "error"
  "no-lonely-if": "error"
  "no-mixed-operators": "error"
  "no-multiple-empty-lines": "error"
  "no-tabs": ["error", { "allowIndentationTabs": true }]
  "no-tabs": ["error"]
  "no-trailing-spaces": "error"
  "computed-property-spacing": ["error", "never"]
  "func-call-spacing": ["error", "never"]
  "keyword-spacing": ["error", { "after": true , "before": true}]
  "lines-between-class-members": ["error", "never"]
  "indent": ["error", "tab"]
  "indent": ["error", "tab", { "outerIIFEBody": 0 }]
  "multiline-comment-style": ["error", "separate-lines"]
  "multiline-comment-style": ["error", "bare-block"]
  "multiline-comment-style": ["error", "starred-block"]
  "no-unneeded-ternary": "error"
  "no-whitespace-before-property": "error"
  "operator-linebreak": ["error", "after"]
  "quotes": ["error", "single", { "avoidEscape": true }]
  "quotes": ["error", "double", { "avoidEscape": true }]
  "semi": ["error", "always"]
  "space-before-blocks": "error"
  "space-in-parens": ["error", "never"]
  "space-infix-ops": "error"
  "space-unary-ops": "error"
  "switch-colon-spacing": "error"
  "spaced-comment": ["error", "always", { "line": { "exceptions": ["-"] }, "block": { "balanced": true } }]
