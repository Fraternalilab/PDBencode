
SCRIPT_DIR="/home/jkleinj/develop/PDBencode/Rscript"
DATA_DIR="/home/jkleinj/develop/PDBencode/inst/tools/data"

# initiate docker container
echo "Initialising Docker container"
sudo docker run --ipc=host \
-v "${SCRIPT_DIR}":"${SCRIPT_DIR}" \
-v "${DATA_DIR}":"${DATA_DIR}" \
--name pdbencodedocker \
--cidfile test.cid \
-itd pdbencodedocker

cid=$(cat test.cid)

# run pdbencode inside the container
echo "Running PDBencode ..."
docker exec -it pdbencodedocker Rscript pdbencode.R

# clean up (remove exited docker containers)
#docker stop $cid
#docker rm $(docker ps -q -f status=exited)
#rm test.cid

