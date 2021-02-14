## PDBencode: Encode PDB Structure using Structural Alphabet 
[![release](https://img.shields.io/badge/release-v0.1-green?logo=github)](https://github.com/Fraternalilab/PDBencode)

The package provides the functionality to encode given PDB structures
into Structural Alphabet (SA) strings.

## Usage
Use the script *Rscripts/pdbencode.R* in the directory containing PDB file(s):
```{sh}
Rscript pdbencode.R 
```
All PDB files (with extension ".pdb") in that directory will be processed.
Each structure \<ID\>.pdb yields an encoded \<ID\>_sa.fasta file containing
one SA sequence per chain. The format of SA sequence headers is \<ID\>|\<chain\>.

#### Copyright Holders, Authors and Maintainers 
- 2021 Jens Kleinjung (author, maintainer) jens@jkleinj.eu
- 2021 Franca Fraternali (author, maintainer) franca.fraternali@kcl.ac.uk

