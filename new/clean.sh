pkill kubectl
k3d cluster list
k3d cluster delete <cluster-name>  # repeat for each listed cluster
docker ps -q | xargs -r docker stop
docker ps -aq | xargs -r docker rm
sudo systemctl stop docker.service
sudo systemctl disable docker.service