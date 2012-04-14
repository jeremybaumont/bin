#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  header.pl
#
#        USAGE:  ./header.pl 
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:   (), <>
#      COMPANY:  
#      VERSION:  1.0
#      CREATED:  10/20/2009 03:19:18 PM CEST
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;


sub addheader{

my($infile,$header)=@_;

my $text = do { local( @ARGV, $/ ) = $infile ; <> } ;

open(FILE,">$infile");

print FILE $header;

print FILE $text;

close FILE

}

my $argnum;

foreach $argnum (0 .. $#ARGV){

my $infile = $ARGV[$argnum];

# Edit line below to change header text

my $header = "
#    Copyright (C) 2012 Jeremy Baumont 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
";

&addheader($infile,$header);

}
