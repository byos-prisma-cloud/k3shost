#!/bin/bash
# https://docs.k3s.io/installation/configuration
# https://docs.k3s.io/installation/uninstall

curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.26.4+k3s1" K3S_KUBECONFIG_MODE="644" sh -
sleep 30

# Function to check if the K3s cluster is ready
is_cluster_ready() {
    local output
    output=$(k3s kubectl get pods -A 2>&1)
    if [[ $output != *"the server is currently unable to handle the request"* ]]; then
        return 0  # Cluster is ready
    else
        return 1  # Cluster is not ready
    fi
}

uninstall_k3s() {
    /usr/local/bin/k3s-killall.sh
    /usr/local/bin/k3s-uninstall.sh
}

# Loop until the cluster is ready
while ! is_cluster_ready; do
    echo -e "\nK3s cluster is not ready yet. Sleeping for 5 seconds..."
    sleep 5
done

echo -e "\n\n######### K3s cluster is now ready! #########\n\n"
echo -e "## Run the following command: alias kubectl='k3s kubectl' and then start using your Kubernetes cluster\n\n"

## Uninstall k3s if needed. Uncomment the below line
# uninstall_k3s

## Remove Images
# sudo k3s crictl images
# sudo k3s crictl rmi <image-id>