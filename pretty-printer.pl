#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  pretty-printer.pl
#
#        USAGE:  ./pretty-printer.pl
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
#      CREATED:  01/28/2008 11:59:30 AM CET
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Template;
use Getopt::Long;
use Perl::Tidy;
use File::Temp;

# options par défaut
my $config = {
        output => './prettyprinter-output.pdf',
        config => '/home/jeremyb/.perltidyrc' ,
    };
    
my $usage = "$0: [ --config file ] --input file [ --output file ]\n";

    # paramètres de ligne de commande
GetOptions( $config, "input=s", "output=s", "config=s" )
                or die $usage;
die $usage if ! exists $config->{input};

my $template = Template->new();

# création d’un fichier temporaire
# afin d’y mettre la version embellie du fichier source
my $tmp_source = File::Temp->new( UNLINK => 1,
                     SUFFIX => ".tmp" );

# mise en forme du code source par Perl::Tidy
perltidy(
        source      => $config->{input},
        destination => $tmp_source->filename,
        perltidyrc  => $config->{config},
);

my $output = $config->{output};

# traitement du template
$template->process( \*DATA, { file => $tmp_source->filename }, $output )
        or die $template->error();

__DATA__
[% FILTER latex("pdf") -%]
\documentclass[9pt]{article}

\usepackage{color}
\usepackage{times}
\usepackage{pifont}
\usepackage{pslatex}
\usepackage{fancyhdr}
\usepackage{fancybox}
\usepackage{fullpage}
\usepackage[T1]{fontenc}
\usepackage[french]{babel}
\usepackage[latin1]{inputenc}
\usepackage{listings}

\begin{document}
\lstset{
 language=Perl,          % le langage
 showspaces=false,       % afficher les espaces de manière
                            % visible ou non
 showstringspaces=false, % idem dans les chaînes
 showtabs=false,         % idem pour les tabulations
 numbers=left,           % où afficher les numéros de lignes
 numberstyle=\tiny,      % le style à employer pour les
                            % numéros de lignes
 stepnumber=2,           % le pas d’affichage des numéros
                            % de ligne
 numbersep=5pt,}
\lstinputlisting{[% file -%]}
\end{document}
[% END -%]
