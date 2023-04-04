# this script starts the cluster on microk8s
# it assumes that the cluster is already installed
# and that the user has access to the cluster
# it also assumes that the user has access to the
# docker registry
kubectl config use-context kind-kind

## create the namespace iotstack
kubectl create namespace iotstack
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl apply -f ./k8s/metalb.yml
# check if skaffold is installed and install it if not
if ! command -v skaffold &> /dev/null
then
    echo "skaffold could not be found"
    echo "installing skaffold"
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    chmod +x skaffold
    sudo mv skaffold /usr/local/bin
fi

# run skaffold to build the application and check for errors
skaffold build

# run skaffold to deploy the application to the namespace iotstack and check for errors 
skaffold dev --namespace iotstack --status-check

# check if the application is running
kubectl get pods --namespace iotstack

# run the following command to get the ip address of the ingress
# microk8s kubectl get ingress --namespace iotstack
