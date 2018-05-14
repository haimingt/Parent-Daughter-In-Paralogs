# Parent-Daughter-In-Paralogs
The parent and daughter relationships in paralogous gene pairs in vertebrates. 

The phylogenetic trees structures that were utilized for this study are summarized in Supplemental Material Part 1.
The newick format is used. Each node in the phylogenetic tree is labled with an AN number.
Duplication nodes have formats like "AN2DUPLICATION".
Speciation nodes have formats like "AN85|Teleostei|", where "Teleostei" indicates the inferred ceancestor.
Leaf nodes have formats like "DANRE_AN95", where "DANRE" is the mnemonic label for Danio rerio (zebra fish) in Uniprot Taxonomy. 

________________________

The synteny evidences are summarized in Supplemental Material Part 2.

The format of the file is:

" ********** PTHR24411_AN12 ************* "    
(A duplication node AN12 for PANTHER family PTHR24411, which is a reconstructed gene duplication node in early vertebrates.)

" AN85|Teleostei| -> DANRE_AN95:0..0||	AN96|Teleostei| -> DANRE_AN104:0..0*||	AN105|
Teleostei| -> AN125DUPLICATION;DANRE_AN126:0..0||AN125DUPLICATION;DANRE_AN127:0..0*||A
N125DUPLICATION;DANRE_AN128:0..0||	"

(Here lists the direct descendants of the PTHR24411_AN12. 

For each descendant, a evolutionary history is drawn from the tree structure from the direct descendant to extant gene. Any duplication nodes that were encountered in the evoluionary lineage is extracted. 

AN85|Teleostei| is a speciation node that is the direct child of the PTHR24411_AN12. 
AN95 is the label for an extant DANRE (zebra fish) gene that is in the AN85 clade.

AN96|Teleostei is similar.

The clade of AN105|Teleostei| is more complicated. It has further duplications at AN125, which gives rise to 3 duplicates AN126, AN127 and AN128.

The gene with synteny evidence is labeled with a "*". 

)
_______________________


The synteny evidences were processed giving rise to differnt situations.
The results are in Part 3. The script is in process_conditions.pl

The format of the Part 3 results are like:

Condition:3	PTHR24411_AN12	ParentCopy: DANRE_AN127 SumFrom:AN125DUPLICATIONTo:DAN
RE_AN127	DaughterCopy: DANRE_AN126 SumFrom:AN125DUPLICATION To:DANRE_AN126


Condition:3	(which condition. Condition 4 here indicates a special case of condition 3. For details, refer to the paper) PTHR24411_AN12 (the duplication node at early vertebrate)	ParentCopy: DANRE_AN127 (The parent copy) SumFrom:AN125DUPLICATIONTo:DAN
RE_AN127 (How the branch length of the parent copy is summarized)	DaughterCopy: DANRE_AN126 (The daughter copy) SumFrom:AN125DUPLICATION To:DANRE_AN126 (How the branch length of daughter copy is summarized).


________________________

The branch lengths for each condition is summarzied in Part 4.
The calculate_branch_length.pl is used to get the results.


________________________

The manuscript is avaialble in archive.




