## Kabsch C routine wrapper function
## On the C side there is a matching wrapper function 'wrap_kabsch' to cast data into GSL
kabsch_C <- function(size, X, Y, rmsd) {
  ## fragment size
  stopifnot(is.numeric(size));
  ## structure fragment
  stopifnot(is.numeric(X));
  ## structural alphabet fragment
  stopifnot(is.numeric(Y));

    out = .C("wrap_kabsch", as.double(size), as.double(X), as.double(Y), rmsd = numeric(1 + 3*size + 3*size - 1)[[1]], PACKAGE = "PDBencode");
    return(out$rmsd);
}

