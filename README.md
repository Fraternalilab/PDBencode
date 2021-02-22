## PDBencode: Encode PDB structures into Structural Alphabet sequences 
[![release](https://img.shields.io/badge/release-v0.1-green?logo=github)](https://github.com/Fraternalilab/PDBencode)

The package provides the functionality to encode given PDB structures
into Structural Alphabet (SA) strings.


## Installation
There are several ways to install the *PDBencode* package, please choose one of the following.
You need to have R installed and the *bio3d* package.

### Linux shell
Download the [latest *PDBencode* release (.tar.gz)](https://github.com/Fraternalilab/PDBencode/releases/latest)
and install on the shell with (example for version 0.1):
```{sh}
R CMD INSTALL PDBencode-v.0.1.tar.gz
```

### R console
Download the [latest *PDBencode* release (.tar.gz)](https://github.com/Fraternalilab/PDBencode/releases/latest) and
install from the R console (example for version 0.1, assuming it is located in the current directory):
```{r}
install.packages("./PDBencode-v.0.1.tar.gz")
```

### R console with devtools
Install the *devtools* package and install *PDBencode* directly from GitHub:
```{r}
library("devtools")
install_github("Fraternalilab/PDBencode")
```


## Usage
Run the script *Rscripts/pdbencode.R* in the directory containing PDB file(s):
```{sh}
Rscript pdbencode.R 
```
All PDB files (with extension ".pdb") in that directory will be processed.
Each structure \<ID\>.pdb yields an encoded \<ID\>_sa.fasta file containing
one SA sequence per chain. The format of SA sequence headers is \<ID\>|\<chain\>.

#### Copyright Holders, Authors and Maintainers 
- 2021 Jens Kleinjung (author, maintainer) jens@jkleinj.eu
- 2021 Franca Fraternali (author, maintainer) franca.fraternali@kcl.ac.uk

