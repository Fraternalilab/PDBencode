## PDBencode: Encode PDB structures into Structural Alphabet sequences 
[![release](https://img.shields.io/badge/release-v0.5-green?logo=github)](https://github.com/Fraternalilab/PDBencode)

The package provides the functionality to encode given PDB structures
into Structural Alphabet (SA) strings.


## Installation
There are several ways to install the *PDBencode* package, please choose one of the following.
For the *Install* options you need to have R installed and the *bio3d* package.
Alternatively the Docker container provides a mode to run *PDBencode* without explicit installation.

### Install on Linux shell
Download the [latest *PDBencode* release (.tar.gz)](https://github.com/Fraternalilab/PDBencode/releases/latest)
and install on the shell with (example for version 0.4):
```{sh}
R CMD INSTALL PDBencode-v.0.4.tar.gz
```

### Install on R console
Download the [latest *PDBencode* release (.tar.gz)](https://github.com/Fraternalilab/PDBencode/releases/latest) and
install from the R console (example for version 0.1, assuming it is located in the current directory):
```{r}
install.packages("./PDBencode-v.0.4.tar.gz")
```

### Install on R console with devtools
Install the *devtools* package and install *PDBencode* directly from GitHub:
```{r}
library("devtools")
install_github("Fraternalilab/PDBencode")
```

## Docker container
Run *PDBencode* in a Docker container.
Use the bash provided in PDBencode/inst/tools:
```{sh}
./buildDockerImage.bash
./pdbencode.bash <path_to_data> <path_to_script>
```
In most cases the user wants to provide the path to the (structure) data,
while that path to the script is optional in case a modified script is to be used.


## Usage
### Option 1 (not for Docker container)
Run the R script *Rscripts/pdbencode.R* in the directory containing PDB file(s):
```{sh}
Rscript pdbencode.R 
```
All PDB files (with extension ".pdb") in that directory will be processed.
Each structure \<ID\>.pdb yields an encoded \<ID\>.sasta file containing
one SA sequence per chain. The format of SA sequence headers is \<ID\>|\<chain\>.

You may run this command on the Docker container as well, but it will only
process the example data in *extdata*.

### Option 2
Provide the path to the data directory as command line parameter.
The R script accepts 3 command line options:
- *--data* : Path to the data directory
- *--script* : Path to the directory containing the R script
- *--cif* : Flag to process ".cif" files instead of ".pdb" files.
- *--help* : Help for command line arguments

```{sh}
Rscript pdbencode.R --data <path_to_data>
```
The script path is intended to be used for a modified *pdbencode.R* script.
For most purposes the built-in script should suffice.


#### Copyright Holders, Authors and Maintainers 
- 2021-2026 Jens Kleinjung (author, maintainer) jens@jkleinj.eu
- 2021-2026 Franca Fraternali (author, maintainer) franca.fraternali@kcl.ac.uk

