#! /bin/bash

#===============================================================================
# PDBencode
# pdbencode.bash
# encodes structures in specified data directory
# requires the pdbencodedocker image (see buildDockerImage.bash)
# - first command line argument is path to data directory containing structures
# - second command line argument is path to 'pdbencode.R' script
# without command line arguments, the intrinsic script and data will be used
#===============================================================================

echo "Usage: pdbencode.bash <path_to_data> <path_to_script>"

DATA_DIR="/usr/local/lib/R/site-library/PDBencode/tools/data"
SCRIPT_DIR="/usr/local/lib/R/site-library/PDBencode/tools"

[[ ! -z "$1" ]] && { DATA_DIR=$1 ; }
[[ ! -z "$2" ]] && { SCRIPT_DIR=$2 ; }

echo "Data directory: ${DATA_DIR}"
echo "Script directory: ${SCRIPT_DIR}"

#_______________________________________________________________________________
## initiate docker container
echo "Initialising Docker container"
sudo docker run --ipc=host \
-v "${DATA_DIR}":"${DATA_DIR}" \
-v "${SCRIPT_DIR}":"${SCRIPT_DIR}" \
--name pdbencodedocker \
--cidfile pdbencodedocker.cid \
-itd pdbencodedocker

cid=$(cat pdbencodedocker.cid)

#_______________________________________________________________________________
## run pdbencode inside the container
echo "Running PDBencode ..."
docker exec -it pdbencodedocker Rscript ${SCRIPT_DIR}/pdbencode.R --data ${DATA_DIR}

#_______________________________________________________________________________
## clean up (remove exited docker containers)
docker stop $cid
docker rm $(docker ps -q -f status=exited)
rm pdbencodedocker.cid

#===============================================================================

