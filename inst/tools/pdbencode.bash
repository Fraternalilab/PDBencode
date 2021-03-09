#! /bin/bash

#===============================================================================
# PDBencode
# pdbencode.bash
# encodes structures in specified data directory
# requires the pdbencodedocker image (see buildDockerImage.bash)
# - first command line argument is path to 'pdbencode.R' script
# - second command line argument is path to data directory containing structures
# without command line arguments, the intrinsic script and data will be used
#===============================================================================

echo "Usage: pdbencode.bash <path_to_script> <path_to_data>"
echo "  for example:"
echo "    <path_to_script>: /home/<user>/PDBencode/Rscripts"
echo "    <path_to_data>: /home/<user>/PDBencode/inst/tools/data"

SCRIPT_DIR="/usr/local/lib/R/site-library/PDBencode/tools"
DATA_DIR="/usr/local/lib/R/site-library/PDBencode/tools/data"

[[ ! -z "$1" ]] && { SCRIPT_DIR=$1 }
[[ ! -z "$2" ]] && { DATA_DIR=$2 }

echo "Script directory: ${SCRIPT_DIR}"
echo "Data directory: ${DATA_DIR}"

#_______________________________________________________________________________
## initiate docker container
echo "Initialising Docker container"
sudo docker run --ipc=host \
-v "${SCRIPT_DIR}":"${SCRIPT_DIR}" \
-v "${DATA_DIR}":"${DATA_DIR}" \
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

