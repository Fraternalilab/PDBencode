#!/usr/bin/env Rscript

#===============================================================================
# PDBencode script for the Docker container 
# Read PDB structure(s) in mounted (and argument-passed) directory
# Use this R script by default unless a different script is
#   mounted and argument-passed
# Encode structure(s) and write SA string(s) as FASTA format
# Each chain is encoded separately
#===============================================================================

library("PDBencode")
library("bio3d")
library("optparse")

#_______________________________________________________________________________
## directory paths for R script and data
## default paths in the Docker container
dataDir = "."
scriptDir = "."

option_list = list(
  make_option(c("-d", "--data"), type = "character", default = ".",
              help = "data path", metavar = "character"),
  make_option(c("-s", "--script"), type = "character", default = ".",
              help = "R script path", metavar = "character"),
  make_option(c("-c", "--cif"), type = "character", default = FALSE,
              action = "store_true",
              help = "structure in mmCIF format", metavar = "character")
);

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (! is.null(opt$data)) {
  dataDir = opt$data
}
if(! is.null(opt$script)) {
  scriptDir = opt$script
}

#_______________________________________________________________________________
## input structure(s)
if (opt$cif == FALSE) {
  strs = list.files(path = dataDir, pattern = "\\.pdb$")
} else {
  strs = list.files(path = dataDir, pattern = "\\.cif$")
}

message("Input structures:")
message(paste(strs, "\n"))

## for all input structures
for (i in 1:length(strs)) {
	## this structure
	str = strs[i];
	## structure name
	str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
	## read structure, only first MODEL is used if several present
	if (opt$cif == FALSE) {
	  ## default is PDB format
	  str_bio3d = bio3d::read.pdb(paste(dataDir, str, sep = '/'))
	} else {
	  str_bio3d = bio3d::read.cif(paste(dataDir, str, sep = '/'))
	}
	## chains
	chains = unique(str_bio3d$atom$chain)
	## for each chain
	sa_stack.fasta = unlist(sapply(1:length(chains), function(j) {
		message(paste("Chain", j, chains[j]))
	  ## indices of Calpha atoms only and this chain
		ca.inds = bio3d::atom.select(str_bio3d, "calpha", chain = chains[j])
		## in case the chain does not contain enough protein sequence
		if (length(ca.inds$atom) < 4) {
		  message("  Chain not encoded: <4 CA atoms")
		  return()
		}
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
	}))
	
	## write stacked sequences, all chains of this structure
	write.table(sa_stack.fasta, file = paste(dataDir, "/", str_name, ".sasta", sep = ''),
		quote = FALSE, row.names = FALSE, col.names = FALSE)
}

#===============================================================================

