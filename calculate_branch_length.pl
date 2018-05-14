# this is the script to analyze the branch length 
# there are 3 differnt situations
# 1 is only 1 duplication after the a duplication in early vertebrates
# 2 is multiple duplications after a duplication in early vertebrates, but the synteny evidence is not in deepest duplication node
# 3 is multiple duplications after a duplication in early vertebrates, but the synteny evidence is in the deepest duplication node

use List::Util qw( sum);

my $file =shift;
=pod
open OUT1, "> 54_c1.txt" or die; #condition 1
open OUT2, "> 54_c2.txt" or die; #condition 2
open OUT3, "> 54_c3_deepest.txt" or die; #condition 3, the branch comparison of the deepest pair
open OUT4, "> 54_c3_other.txt" or die;# condition 3, the branch comparison of the other pairs
=cut
# should also print From which duplication node, to which extant gene. the branch length and how things added up
# lable the extant gene with synteny evidence (the parent copy) with a star

my $newickd = "/auto/pmd-02/pdt/pdthomas/panther/proj/csnp_2013/treeanalysis/";

open IN, "< $file" or die;
my @info = <IN>; # just save the info
close IN;

my $node;


foreach my $item (@info){
  my $wheres;
  if ($item =~ /\*\*\ (PTHR[0-9\_AN]+) \*\*/){
    print "$item";
    $node = $1;
  }
  else{
    print "\nprocessing $item\n";
    chomp($item);
    my @array = split (/\t/,$item);
    my ($S,$D,$M) = &sumarize(\@array);
    # $S, those with synteny evidences
    # $D, further duplications
    # $M, for missing

    my $size = scalar @array; # the number of descendants of a duplication node

    # if there are multiple stars.
    # we can still find the one group with duplications, and show evidences there

    my $ssum = sum(@$S);
    if ($ssum >= 2){
      $wheres =1 ;
      my $has;
      foreach my $i (0..$size-1){
	if ($D->[$i] ==1){
	  if ($S->[$i] ==1){
	    ## ok, find one with duplication nodes and star
	    #treat with this
	    # but this is not necessarily the deepest.
	    # if it is the deepest, then it is condition 3
	    # else, it is condition 2

	    $has =1 ;
	    my $theorinode;
	    my $largestnd =0;
	    my $syntenynd =0;

	    my @aa;

	    my $read = $array[$i];
	    my $number = () = $read =~ /\*/g;
	    if ($number ==1){
	      @aa = split(/\|\||\>/,$read);	      
	      my $ori;
	      my $other;
	      foreach my $ditem (@aa){
		my $nd = () = $ditem =~ /DUPLICATION/g;
		if ($nd > $largestnd){
		  $largestnd = $nd;
		}
		if ($ditem =~ /\*/){
		  $syntenynd = $nd;
		}
	      }
	    }
	    if ($syntenynd == $largestnd){
	      my $startDup;
	      my $theorinode;
	      foreach my $ditem (@aa){
		if ($ditem =~ /\*/){
		  if ($ditem =~ /(AN[0-9]+DUPLICATION);(\w+_AN[0-9]+)/){
		    $ori = "ParentCopy: ".$2." SumFrom:$1 To:$2";
		    $theorinode = $2;
		    $startDup = $1;
		  }
		}
	      }
	      foreach my $ditem (@aa){
		next if ($ditem =~ /\*/);
	       
		if ($ditem =~ /(AN[0-9]+DUPLICATION);(\w+_AN[0-9]+)/){
		  my $other = "DaughterCopy: ".$2." SumFrom:$1 To:$2";

		  if ($1 eq $startDup){
		    print  "Condition:3\t$node\t";
		    print "ParentCopy: $theorinode SumFrom:$1To:$theorinode\t";
		    print "DaughterCopy: $2 SumFrom:$1 To:$2\n";
		  }
		  else{
		    print "Condition:4\t$node\t";
		    print "ParentCopy: $theorinode SumFrom:lca of $theorinode and $2 To:$theorinode\t";
		    print "DaughterCopy: $2 SumFrom:lca of $theorinode and $2 To:$2\n";
		  }
		}
	      }	    
	    }
	    else { # if the one with synteny evidence not in the deepest node
	      my $startDup;
	      my $theorinode;
	      foreach my $ditem (@aa){
		if ($ditem =~ /\*/){
		  if ($ditem =~ /(AN[0-9]+DUPLICATION);(\w+_AN[0-9]+)/){
		    $ori = "ParentCopy: ".$2." SumFrom:$1 To:$2";
		    $theorinode = $2;
		    $startDup = $1;
		    last;
		  }
		}
	      }
	      foreach my $ditem (@aa){
		next if ($ditem =~ /\*/);
		if ($ditem =~ /(\w+_AN[0-9]+):/){
		  my $daughter = $1;
		  print "Condition:2\t$node\t";
		  print "ParentCopy: $theorinode SumFrom:lca of $daughter and $theorinode To:$theorinode\t";
		  if ($ditem =~ /DUPLICATION/){
		    print "FurtherDuplication:";
		  }
		  print "DaughterCopy: $daughter SumFrom:lca of $daughter and the $theorinode To:$daughter\n";
		}
	      }
	    }
	  }
	}
      }

      unless ($has ==1){
	print "omit this case!\n";
      }
    }
    else{ # systeny evidence just equal to 1

      foreach my $i (0..$size-1){
	if ($D->[$i] ==1){
	  if ($S->[$i] ==1){
	    ## ok, find one with duplication nodes and star
	    #treat with this
	    # but this is not necessarily the deepest.
	    # if it is the deepest, then it is condition 3
	    # else, it is condition 2

	    $wheres =1;
	    my $theorinode;
	    my $largestnd =0;
	    my $syntenynd =0;

	    my @aa;

	    my $read = $array[$i];
	    my $number = () = $read =~ /\*/g;
	    if ($number ==1){
	      @aa = split(/\|\||\>/,$read);	      
	      my $ori;
	      my $other;
	      foreach my $ditem (@aa){
		my $nd = () = $ditem =~ /DUPLICATION/g;
		if ($nd > $largestnd){
		  $largestnd = $nd;
		}
		if ($ditem =~ /\*/){
		  $syntenynd = $nd;
		}
	      }
	    }
	    else{
	      print "Omit this case!\n";
	      last;
	    }
	    if ($syntenynd == $largestnd){
	      my $startDup;
	      my $theorinode;
	      foreach my $ditem (@aa){
		if ($ditem =~ /\*/){
		  my $nd = () = $ditem =~ /DUPLICATION/g;
		  next unless $nd eq $largestnd;
		  if ($ditem =~ /(AN[0-9]+DUPLICATION);(\w+_AN[0-9]+)/){
		    $ori = "ParentCopy: ".$2." SumFrom:$1 To:$2";
		    $theorinode = $2;
		    $startDup = $1;
		    last;
		  }
		}
	      }
	      foreach my $ditem (@aa){
		next if ($ditem =~ /\*/);
	       
		if ($ditem =~ /(AN[0-9]+DUPLICATION);(\w+_AN[0-9]+)/){
		  my $other = "DaughterCopy: ".$2." SumFrom:$1 To:$2";

		  if ($1 eq $startDup){
		    print  "Condition:3\t$node\t";
		    print "ParentCopy: $theorinode SumFrom:$1 To:$theorinode\t";
		    print "DaughterCopy: $2 SumFrom:$1 To:$2\n";
		  }
		  else{
		    print "Condition:4\t$node\t";
		    print "ParentCopy: $theorinode SumFrom:lca of $theorinode and $2 To:$theorinode\t";
		    print "DaughterCopy: $2 SumFrom:lca of $theorinode and $2 To:$2\n";
		  }
		}
	      }	    
	      foreach my $j (0..$size-1){
		next if ($j == $i);
		my $theread = $array[$j];
		if ($theread =~ /^(AN[0-9]+).*[^\w](\w+_AN[0-9]+):/){ # not necessinarily after a duplication node, or shouldn't after a duplication node
		  # this is condition 4
		  print "Condition:4\t$node\t";
		  print "ParentCopy: $theorinode SumFrom:mom of $1 To:$theorinode\t";
		  print "DaughterCopy: $2 SumFrom:mom of$1 To:$2\n";
		}
	      }
	    }
	    else { # if the one with synteny evidence not in the deepest node
	      my $startDup;
	      my $theorinode;
	      foreach my $ditem (@aa){
		if ($ditem =~ /\*/){
		  if ($ditem =~ /(AN[0-9]+DUPLICATION);(\w+_AN[0-9]+)/){
		    $ori = "ParentCopy: ".$2." SumFrom:$1 To:$2";
		    $theorinode = $2;
		    $startDup = $1;
		    last;
		  }
		}
	      }
	      foreach my $ditem (@aa){
		next if ($ditem =~ /\*/);
		if ($ditem =~ /(\w+_AN[0-9]+):/){
		  my $d = $1;
		  print "Condition:2\t$node\t";
		  print "ParentCopy: $theorinode SumFrom:lca of $d and $theorinode To:$theorinode\t";
		  if ($ditem =~ /DUPLICATION/){
		    print "FurtherDuplication:";
		  }
		  print "DaughterCopy: $1 SumFrom:lca of $d and the $theorinode To:$d\n";
		}
	      }
	      foreach my $j (0..$size-1){
		next if ($j == $i);
		my $theread = $array[$j];
		while ($theread =~ /(\w+_AN[0-9]+):/g){ # not necessinarily after a duplication node, or shouldn't after a duplication node
		  # this is condition 2
		  print "Condition:2\t$node\t";
		  print "ParentCopy: $theorinode SumFrom:lca of $1 and $theorinode To:$theorinode\t";
		  print "DaughterCopy: $1 SumFrom:lca of $1 and $theorinode To:$2\n";
		}
	      }
	    }
	  }
	}
      }
    }
  
    if ($wheres ==0){ # I think this is the simpler condition 1
      # no duplication 
      # may contain condition 2 too. If other nodes have been further duplicated
      # Need to go up a little bit to find the duplication node
    
      my $dsum = sum(@$D);
      my $condition = 2;
      if ($dsum <1){ # if this is condition 1, no further duplication
	$condition = 1;
      }
    
      foreach my $i (0..$size-1){
	if ($S->[$i] ==1){ # this is the one with synteny evidence
	  my $read = $array[$i];
	  my $ori;
	  
	  if ($read =~ /^(AN[0-9]+).*[^\w](\w+_AN[0-9]+):[0-9\.]+/){
	    $ori = "ParentCopy: ".$2." SumFrom:mom of $1 To:$2";;
	  }
	  
	  my $otherother;
	  foreach my $j (0..$size-1){
	    next if ($j == $i);
	    my $theread = $array[$j];
	  
	    if ($theread =~ /DUPLICATION/){
	      $otherother .= "FurtherDuplication".":";
	    }
	  
	    while ($theread =~ /[^\w](\w+_AN[0-9]+):/g){
	      $otherother .= "\tDaughterCopy: ".$1." SumFrom: To:$1";
	    }
	  }
	  print "Condition:$condition\t";
	  print "$ori\t";
	  print "$otherother\n";
	  
	}
      }	
    } 
  }
}

sub sumarize{
  my $ref =shift;
  my @arr = @$ref;
  my @S;
  my @D;
  my @M;

  foreach my $item (@arr){
    if ($item =~ /\*/){
      push(@S,1);
    }
    else{
      push(@S,0);
    }
    if ($item =~ /DUPLICATION/){
      push(@D,1);
    }
    else{
      push(@D,0);
    }
    if ($item =~ /\|\|/){
      push(@M,0);
    }
    else{
      push(@M,1);
    }

  }

  return (\@S,\@D,\@M);
}




