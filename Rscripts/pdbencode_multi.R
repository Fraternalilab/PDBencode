#!/usr/bin/env Rscript

#===============================================================================
# PDBencode script for multi-model PDBs for the Docker container
# Read PDB structure(s) in mounted (and argument-passed) directory
# Use this R script by default unless a different script is
#   mounted and argument-passed
# Encode all PDB MODEL structure(s) and write SA string(s) as FASTA format
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
  make_option(c("-d", "--data"), type = "character", default = NULL,
              help = "data path", metavar = "character"),
  make_option(c("-s", "--script"), type = "character", default = NULL,
              help = "R script path", metavar = "character")
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
strs = list.files(path = dataDir, pattern = "\\.pdb$")
message("Input structures:")
message(paste(strs, "\n"))

## for all input structures
for (i in 1:length(strs)) {
	## this structure
	str = strs[i]
	## structure name
	str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
	## read structure, potentially containing multiple models
	message(paste("Reading PDB file:", paste(dataDir, str, sep = '/')))
	str_bio3d = bio3d::read.pdb(paste(dataDir, str, sep = '/'), multi = TRUE)

		## iterate over MODELs
	n_models <- nrow(str_bio3d$xyz)

	## chains
	chains = unique(str_bio3d$atom$chain)
	
	message(paste("\tprocessing", n_models, "models, each with", length(chains), "chain(s)"))
	
	## for each chain
	sa_stack_sasta.l = lapply(1:length(chains), function(k) {
	  sa_stack_sasta.v = sapply(1:n_models, function(j) {
	    if (j %% 100 == 0) { message(paste("\t\tNumber of encoded models:", j))}
	    #message(paste("Chain", k, chains[k]))
	    
	    ## indices of Calpha atoms only and this chain
		  ca.inds = bio3d::atom.select(str_bio3d, "calpha", chain = chains[k])
		  ## in case the chain does not contain enough protein sequence
		  if (length(ca.inds$atom) < 4) {
		    message("  Chain not encoded: <4 CA atoms")
		    return()
		  }
		  # subset PDB structure with indices
		  str_bio3d_ca = trim.pdb(str_bio3d, ca.inds)

  		#_______________________________________________________________________________
  		## encode structure
  		sa_char.v = encode(str_bio3d_ca$xyz[j, ])
  		## from vector of chars to (vector of) string
  		sa_string.v = paste(sa_char.v, collapse = '')
  		## Structural Alphabet sequence in FASTA format
  		return(sa_string.v)
  	})
	  
	  return(sa_stack_sasta.v)
	})
	
	names(sa_stack_sasta.l) = chains
	
	## write the stacked sastas of each chain
	for (l in 1:length(chains)) {
	  write.table(sa_stack_sasta.l[[l]], file = paste(dataDir, "/", str_name, "_", chains[l], ".sasta", sep = ''),
	              quote = FALSE, row.names = FALSE, col.names = FALSE)
	}
}

#===============================================================================

