#!/usr/bin/perl

$stem=$ARGV[0];
$rules=$ARGV[1];

if(!defined($stem) || !defined($rules)) {die("Convert 3 rules to a level 2 decision tree\nuse : <stem> <rules files>\n");}

open(STEM,"$stem.names") || die("Can't open $stem.names\n");
$nb_attribut=0;
while(<STEM>)
{
	if(/^[|#]/ || /^\s*$/) {next;}
	if(s/\s*(\S+)\s*:\s*([^\s\.,:]+)/$2/)
	{
		#print STDERR "$1:$2.\n";
		$nom=$1;
		$position_attribut{$nom}=$nb_attribut; 
		$type_attribut{$nom}=$2;  
		$laut{$nom}=0;
		if(/,/) 
		{
			$laut{$nom}=1;
			$type_attribut{$nom}="discret";
			while(s/[^,\.\s]+//)
			{
				$autorise{$nom}{$&}++;
			}
		} #dans le cas des listes de valeurs possibles
		$type_attribut{$nom}=~s/continuous/numeric/;
		$nb_attribut++;
	}
	elsif(/,/)#les labels
	{
		while(s/[^\s,\.]+//) {$labels{$&}++;}
	}
}
close(STEM);


open(RULE,$rules) || die("Can't open $rules\n");
while(<RULE>)
{
	if(/(yes|no)=(\S+)\s+(\S+)\s+(yes|no)=(\S+)\s+(yes|no)=(\S+)/)
	{
		$branche=$1;
		$att=$2;
		$val=$3;
		
		if($4 eq "yes")
		{
			$oui=$5;
			$non=$7;
		}
		else
		{
			$non=$5;
			$oui=$7;
		}
		
		if(!exists($labels{$oui})){die"Error: $oui is not a valid label\n";} 
		if(!exists($labels{$non})){die"Error: $non is not a valid label\n";} 
		
		$roui{$branche}=$oui;
		$rnon{$branche}=$non;
		
		if(!exists($type_attribut{$att})){die"Error: Attribute \"$att\" does not exist in $stem.names\n";} 
		elsif($type_attribut{$att} eq "ignore"){print STDERR "Error: Attribute \"$att\" is marked ignore in $stem.names\n";}
		$attribut{$branche}=$att; 
		$valeur{$branche}=$val; 
		if($laut{$att}==1 && !exists($autorise{$att}{$val})){print STDERR "Error: value \"$val\" does not belong to the autorized values in $stem.names\n";}

	}
	elsif(/(racine)=(\S+)\s+(\S+)/)
	{
		$branche=$1;
		$att=$2;
		$val=$3;
		if(!exists($type_attribut{$att})){die"Error: Attribute \"$att\" does not exist in $stem.names\n";} 
		elsif($type_attribut{$att} eq "ignore"){print STDERR "Error: Attribute \"$att\" is marked ignore in $stem.names\n";}
		$attribut{$branche}=$att; 
		$valeur{$branche}=$val; 
		if($laut{$att}==1 && !exists($autorise{$att}{$val})){print STDERR "Error: value \"$val\" does not belong to the autorized values in $stem.names\n";}
	}
	else{print STDERR "Ignore line:$_";}
}
close(RULE);




open(STEM,">$stem.tree.xml") || die("Can't create $stem.tree.xml\n");
print STEM "<run algorithm=\"Tree\" induction=\"Entropie\" min_leaf_size=\"0\" gain=\"1e-08\" mdlpc=\"false\" nb_rounds=\"2\" depth=\"10000\" fs=\"0\" bs=\"0.62\">";
print STEM "<target_labels";
$nb_l=0;
foreach $l (sort keys %labels)
{
	print STEM " $nb_l=\"$l\"";
	$labels{$l}="$nb_l";
	$nb_l++;
}

print STEM "/>";
print STEM "<tree><node type=\"node\">";
print STEM "<question gain=\"19\" position=\"$position_attribut{$attribut{\"racine\"}}\" name=\"$attribut{\"racine\"}\" type=\"$type_attribut{$attribut{\"racine\"}}\" patron=\"$valeur{\"racine\"}\"/>";
print STEM "<population 0=\"1\" 1=\"9\"/>";
print STEM "<node type=\"node\">";
print STEM "<question gain=\"19\" position=\"$position_attribut{$attribut{\"yes\"}}\" name=\"$attribut{\"yes\"}\" type=\"$type_attribut{$attribut{\"yes\"}}\" patron=\"$valeur{\"yes\"}\"/>";
print STEM "<population 0=\"2\" 1=\"3\"/><node type=\"leaf\"><population $labels{$roui{\"yes\"}}=\"1\"/></node>";
print STEM "<node type=\"leaf\"><population $labels{$rnon{\"yes\"}}=\"1\"/></node></node>";
print STEM "<node type=\"node\">";
print STEM "<question gain=\"19\" position=\"$position_attribut{$attribut{\"no\"}}\" name=\"$attribut{\"no\"}\" type=\"$type_attribut{$attribut{\"no\"}}\" patron=\"$valeur{\"no\"}\"/>";
print STEM "<population  0=\"2\" 1=\"3\"/><node type=\"leaf\"><population $labels{$roui{\"no\"}}=\"1\"/></node>";
print STEM "<node type=\"leaf\"><population $labels{$rnon{\"no\"}}=\"1\"/></node></node></node>";
print STEM "</tree></run>";

close(STEM);

