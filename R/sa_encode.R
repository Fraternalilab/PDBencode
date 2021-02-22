#===============================================================================
# PDBencode
#' sa_encode.R
#'
#' Encode a protein structure with the M32K25 structural alphabet.
#'
#' Given a PDB structure, this function will fit C-alpha
#' coordinates of all consecutive 4-residue fragments with the canonical
#' fragments of the M32K25 structural alphabet, selecting the optimal
#' (lowest RMSD) fragment in each case.
#===============================================================================

#_______________________________________________________________________________
#' sadata: An S4 class for Structural Alphabet (SA) data.
#' @slot fragment_letters: Prototype fragment letters forming SA.
#' @slot fragment_coordinates: Coordinates of prototype fragments.
sadata <- setClass(
  "sadata",
  
  slots = c(
    fragment_letters = "vector",
    fragment_coordinates = "list"
  )
)

#_______________________________________________________________________________
## assign the M32K25 structural alphabet
.assign_M32K25 = function(sadata_o) {
  ## fragment letters
  sadata_o@fragment_letters = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y');

  ## fragment coordinates: 4 Calpha atoms per fragment (vector)
  ## format per fragment: x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4
  sadata_o@fragment_coordinates = list(
    c(  2.630,  11.087,-12.054,  2.357,  13.026,-15.290,   1.365,  16.691,-15.389,   0.262,  18.241,-18.694), #A, 1
    c(  9.284,  15.264, 44.980, 12.933,  14.193, 44.880,  14.898,  12.077, 47.307,  18.502,  10.955, 47.619), #B, 2
    c( 25.311,  23.402, 33.999, 23.168,  25.490, 36.333,  23.449,  24.762, 40.062,  23.266,  27.976, 42.095), #C, 3
    c( 23.078,   3.265, -6.609, 21.369,   6.342, -4.176,  20.292,   6.283, -0.487,  17.232,   7.962,  1.027), #D, 4
    c( 72.856,  22.785, 26.895, 70.161,  25.403, 27.115,  70.776,  28.306, 29.539,  69.276,  31.709, 30.364), #E, 5
    c( 41.080,  47.709, 33.614, 39.271,  44.390, 33.864,  36.049,  44.118, 31.865,  32.984,  43.527, 34.064), #F, 6
    c( 59.399,  59.100, 40.375, 57.041,  57.165, 38.105,  54.802,  54.093, 38.498,  54.237,  51.873, 35.502), #G, 7
    c( -1.297,  14.123,  7.733,  1.518,  14.786,  5.230,   1.301,  17.718,  2.871,  -0.363,  16.930, -0.466), #H, 8
    c( 40.106,  24.098, 63.681, 40.195,  25.872, 60.382,  37.528,  27.160, 58.053,  37.489,  25.753, 54.503), #I, 9
    c( 25.589,   1.334, 11.216, 27.604,   1.905, 14.443,  30.853,  -0.042, 14.738,  30.051,  -1.020, 18.330), #J,10
    c( 17.239,  71.346, 65.430, 16.722,  74.180, 67.850,  18.184,  77.576, 67.092,  20.897,  77.030, 69.754), #K,11
    c( 82.032,  25.615,  4.316, 81.133,  23.686,  7.493,  83.903,  21.200,  8.341,  81.485,  19.142, 10.443), #L,12
    c( 28.972,  -1.893, -7.013, 28.574,  -5.153, -5.103,  30.790,  -7.852, -6.647,  30.144, -10.746, -4.275), #M,13
    c( -4.676,  72.183, 52.250, -2.345,  71.237, 55.105,   0.626,  71.396, 52.744,   1.491,  72.929, 49.374), #N,14
    c(  0.593,  -3.290,  6.669,  2.032,  -2.882,  3.163,   4.148,  -6.042,  3.493,   7.276,  -4.148,  2.496), #O,15
    c( 29.683,  47.318, 25.490, 26.781,  47.533, 27.949,  26.068,  51.138, 26.975,  27.539,  52.739, 30.088), #P,16
    c( 34.652,  36.550, 18.964, 33.617,  37.112, 15.311,  32.821,  40.823, 15.695,  34.062,  43.193, 12.979), #Q,17
    c(  8.082,  44.667, 15.947,  5.161,  46.576, 17.520,   5.855,  49.813, 15.603,   3.022,  50.724, 13.161), #R,18
    c( 64.114,  65.465, 28.862, 63.773,  68.407, 26.422,  67.481,  69.227, 26.232,  67.851,  68.149, 22.610), #S,19
    c( 18.708,-123.580,-46.136, 18.724,-126.113,-48.977,  18.606,-123.406,-51.661,  14.829,-123.053,-51.400), #T,20
    c( 61.732,  49.657, 35.675, 62.601,  46.569, 33.613,  65.943,  46.199, 35.408,  64.205,  46.488, 38.806), #U,21
    c( 88.350,  40.204, 52.963, 86.971,  39.540, 49.439,  85.732,  36.159, 50.328,  83.085,  37.796, 52.614), #V,22
    c( 23.791,  23.069,  3.102, 26.051,  22.698,  6.166,  23.278,  21.203,  8.349,  21.071,  19.248,  5.952), #W,23
    c(  1.199,   3.328, 36.383,  1.782,   3.032, 32.641,   1.158,   6.286, 30.903,   1.656,   8.424, 34.067), #X,24
    c( 33.001,  12.054,  8.400, 35.837,  11.159, 10.749,  38.009,  10.428,  7.736,  35.586,   7.969,  6.163)  #Y,25
  )
  names(sadata_o@fragment_coordinates) = sadata_o@fragment_letters;

  return(sadata_o);
}

#_______________________________________________________________________________
encode = function(pdb.xyz) {
  sadata_o = new("sadata");
  
  sadata_o = .assign_M32K25(sadata_o);
  
  ## fit all conformation fragments to all alphabet fragments
 	## N-3 structure fragments (and 3 coordinates per fragment)
 	nConfFrag = (length(pdb.xyz) / 3) - 3;
 	nSAFrag = length(sadata_o@fragment_coordinates);
 	## for N-3 input structure fragments
 	rmsd_m = sapply(1:nConfFrag, function(x) {
    	## and 25 SA fragments (structural alphabet letters)
		sapply(1:nSAFrag, function(y) {
			#kabsch_R(pdb.xyz[((3 * x) - 2):((3 * x) + 9)], sadata_o@fragment_coordinates[[y]]);
			kabsch_C(4, pdb.xyz[((3 * x) - 2):((3 * x) + 9)], sadata_o@fragment_coordinates[[y]]);
		});
	});

	## vector of minimal rmsd values
	rmsd_min.v = apply(rmsd_m, 2, min);
	## vector of row indices of minimal rmsd values
	rmsd_min.ix = sapply(1:length(rmsd_min.v), function(z) {
		which(rmsd_m[ , z] %in% rmsd_min.v[z]);
	})

	## fragment string
	fragstring = sadata_o@fragment_letters[rmsd_min.ix];
	# return string of SA fragments
	return(fragstring);
}

#===============================================================================
