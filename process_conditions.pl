use Bio::TreeIO;
use List::Util qw(sum);

my $file = "check4_26.txt";

my $newickdir = "/auto/pmd-02/pdt/pdthomas/panther/proj/csnp_2013/treeanalysis/PANTHER10_newick";

open C, "> conditions.br.txt" or die;

my $pthr;
my $treefile;
my $tree;


open IN, "< $file" or die;
while(<IN>){
  my $line = $_;
  chomp($line);
  $line =~ s/\t/;;/g;
  
  if ($line =~ /\*\* (PTHR[0-9]+)/){
    $pthr = $1;
  }
  elsif ($line =~ /Condition:([0-9]).*ParentCopy:\s([\w_]+)\sSumFrom:([\w_ ]+)To/){
   #elsif ($_ =~ /Condition:([0-9]).*ParentCopy: ([\w_]+) SumFrom:([\w_ ]+)To/){
    my $condition = $1;
    my $parent = $2;
    my $sumfrom = $3;
    
    my $pbr = &getbranchlength($pthr,$parent,$sumfrom);

    my @dbr;
    while($_ =~ /DaughterCopy: (\w+_AN[0-9]+)/g){
      my $dbr = &getbranchlength($pthr,$1,$sumfrom);
      push(@dbr,$dbr);
    }
    my $size = @dbr;
    if ($size <1){
      next;
    }
    else{
      my $mean = sum(@dbr)/$size;
      print C "condition:$condition,$pbr,$mean\n";
    }
  }
}
close IN;
close C;
sub getbranchlength{
  my $pthr = shift;
  my $nodelabel = shift;
  my $sumfrom = shift;

  print "get branch length from $pthr, $nodelabel, $sumfrom\n";

  if ($nodelabel =~ /(AN[0-9]+)/){
    $nodelabel = $1;
  }

  my $thistree = $newickdir."/$pthr.newick";  
  if ($treefile ne $thistree){

    my $targettree = "./NEWICK/$pthr.newick";
    `sed 's/^/\(/' $thistree > $targettree`;

    my $input = Bio::TreeIO->new(-file => $targettree,-format => 'newick');
    $tree = $input->next_tree;
    $treefile = $thistree;
  }

  my $sumnodelabel;
  # deal with sumfrom info first

  if ($sumfrom =~ /mom of (AN[0-9]+)/){
    my $theAN = $1;
    foreach my $node ($tree->get_nodes){
      my $nodeid = $node->id;
      if ($nodeid =~ /(AN[0-9]+)/){
	my $an = $1;
	if ($an eq $theAN){
	  my $ancestornode = $node->ancestor;
	  if ($ancestornode){
	    $sumnodelable = $ancestornode;
	  }
	  else{
	    print STDERR "check ancestor of $theAN\n";
	  }
	  last;
	}
      }
    }
  }
  elsif ($sumfrom =~ /lca of (\w+_AN[0-9]+) and (\w+_AN[0-9]+)/){
    my @nodes;
    my $node1 = $tree->find_node(-id=>$1);
    my $node2 = $tree->find_node(-id=>$2);
    push(@nodes,$node1);
    push(@nodes,$node2);
    my $lca = $tree->get_lca(@nodes);
    if ($lca){
      $sumnodelable = $lca;
    }
    else{
      print STDERR "check lca of $1 and $2\n";
    }
  }
  elsif ($sumfrom =~ /(AN[0-9]+)/){
    my $theAN = $1;
    foreach my $node ($tree->get_nodes){
      my $nodeid = $node->id;
      if ($nodeid =~ /(AN[0-9]+)/){
	if ($1 eq $theAN){
	  $sumnodelable = $node;
	  last;
	}
      }
    }
  }

  my $tracefrom;
  # OK, now get the node;
  foreach my $node ($tree->get_nodes){
    my $nodeid = $node->id;
    if ($nodeid =~ /(AN[0-9]+)/){
      if ($1 eq $nodelabel){
	$tracefrom = $node;
	last;
      }
    }
  }

  my $br = 0;
  
  my $current = $tracefrom;
  while(1){
    $br += $current->branch_length;
    my $mom = $current->ancestor;
    if ($mom eq $sumnodelable){
      $br += $mom->branch_length;
      last;
    }
    else{
      $current = $mom;
    }
  }
  
  return $br;
}


