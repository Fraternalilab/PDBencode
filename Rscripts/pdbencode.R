#===============================================================================
# PDBencode 
# Read PDB structure(s) in local directory
# Encode structure(s) and write SA string(s) as FASTA format
# Each chain is encoded separately
#===============================================================================

library("PDBencode")
library("bio3d")

#_______________________________________________________________________________
## input structure(s)
strs = list.files(pattern = "\\.pdb$")
message("Input structures:")
message(paste(strs, "\n"))

## for all input structures
for (i in 1:length(strs)) {
	## this structure
	str = strs[i];
	## structure name
	str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
	## read structure
	str_bio3d = bio3d::read.pdb2(str)
	## chains
	chains = unique(str_bio3d$atom$chain)
	## for each chain
	sa_stack.fasta = sapply(1:length(chains), function(j) {
		## indices of Calpha atoms only and this chain
		ca.inds = bio3d::atom.select(str_bio3d, "calpha", chain = chains[j])
		# subset PDB structure with indices
		str_bio3d_ca = trim.pdb(str_bio3d, ca.inds)

		#_______________________________________________________________________________
		## encode structure
		sa_char.v = encode(str_bio3d_ca$xyz)
		## from vector of chars to (vector of) string
		sa_string.v = paste(sa_char.v, collapse = '')
		## Structural Alphabet sequence in FASTA format
		sa_string.fasta = sprintf(">%s%s%s\n%s", str_name, "|", chains[j], sa_string.v)
		return(sa_string.fasta)
	})
	## write stacked sequences, all chains of this structure
	write.table(sa_stack.fasta, file = paste(str_name, "_sa.fasta", sep = ''),
		quote = FALSE, row.names = FALSE, col.names = FALSE);
}

#===============================================================================

