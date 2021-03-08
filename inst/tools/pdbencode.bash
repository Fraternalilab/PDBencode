#! /bin/bash

#===============================================================================
# PDBencode
# pdbencode.bash
# encodes structures in specified data directory
# requires the pdbencodedocker image (see buildDockerImage.bash)
# - first command line argument is path to 'pdbencode.R' script
# - second command line argument is path to data directory containing structures
#===============================================================================

echo "Usage: pdbencode.bash <path_to_script> <path_to_data>"
echo "  for example:"
echo "    <path_to_script>: /home/<user>/PDBencode/Rscripts"
echo "    <path_to_data>: /home/<user>/PDBencode/inst/tools/data"

[[ -z "$1" ]] && { echo "Path to script is empty, need first command line argument" ; exit 1; }
[[ -z "$2" ]] && { echo "Path to data is empty, need second command line argument" ; exit 1; }

SCRIPT_DIR=$1
DATA_DIR=$2

# initiate docker container
echo "Initialising Docker container"
sudo docker run --ipc=host \
-v "${SCRIPT_DIR}":"${SCRIPT_DIR}" \
-v "${DATA_DIR}":"${DATA_DIR}" \
--name pdbencodedocker \
--cidfile pdbencodedocker.cid \
-itd pdbencodedocker

cid=$(cat pdbencodedocker.cid)

# run pdbencode inside the container
echo "Running PDBencode ..."
docker exec -it pdbencodedocker Rscript ${SCRIPT_DIR}/pdbencode.R --data ${DATA_DIR}

# clean up (remove exited docker containers)
docker stop $cid
docker rm $(docker ps -q -f status=exited)
rm pdbencodedocker.cid

