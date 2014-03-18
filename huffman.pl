use strict;
use warnings;
use Heap::Simple;
use Tree::Binary;

my $fname = $ARGV[0]; #file name passed in as arg

open (FIN, $fname) or die $!;

my %alphabet;

#read file character by character, incrementing frequencies
while (<FIN>) {
	my $line = $_;
	while ($line) {
		$line =~ s/^(.)(.*)/$2/s;
		if (!$alphabet{$1}) {
			$alphabet{$1} = 0;
		}
		$alphabet{$1} = $alphabet{$1} + 1;
	}
}

#store frequencies in heap
my $heap = Heap::Simple->new(elements => "Array");
my ($char, $freq, $elem);
while (($char, $freq) = each(%alphabet)){
	$heap->insert([$freq, $char]);
}

#construct huffmantree from frequencies
my $huffmanTree;
while ($heap->first) {
	my ($parent, $left, $right, $freq1, $freq2);
	my (@fst, @snd);
	@fst = $heap->extract_top;
	
	if ($heap->first) {
		my $freq1 = $fst[0][0];
		if ($fst[0][1] !~ m/Tree::Binary/s) {
			$left = Tree::Binary->new($freq1);
		}
		else {
			$left = $fst[0][1];
		}
		
		@snd = $heap->extract_top;
		my $freq2 = $snd[0][0];
		if ($snd[0][1] !~ m/Tree::Binary/s) {
			$right = Tree::Binary->new($freq2);
		}
		else {
			$right = $snd[0][1];
		}	
		
		my $parentFreq = $freq1+$freq2;	
		$parent = Tree::Binary->new($parentFreq);
		$parent->setLeft($left);
		$parent->setRight($right);
		
		$heap->insert([$parentFreq, $parent]);
	}
	else {
		$huffmanTree = $fst[0][1];
		next;
	}
}

# Now just need to figure out how big our translation would be.
# For every leaf, get frequency*depth
my $textLen = 0;
$huffmanTree->traverse(sub {
	my ($node) = @_;
	if ($node->isLeaf()) {
		my $nodeVal = $node->getNodeValue;
		my $depth = $node->getDepth;
		$textLen += int($nodeVal)*int($depth);
	}
});

print $textLen;
print "\n";
