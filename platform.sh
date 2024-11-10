#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

KUBECONFIG_DEV_FILE="/tmp/dev.kubeconfig"

# Function definitions
function bootstrap_platform() {
    echo -e "${BLUE}Platform bootstrap...${NC}"
    echo -e "${GREEN}Kind management cluster creation...${NC}"
    kind create cluster --name platform --config docs/0-base-platform/cluster-config.yaml

    echo -e "${GREEN}Installing cluster API components...${NC}"
    export CLUSTER_TOPOLOGY=true
    clusterctl init

    sleep 10
    echo -e "${GREEN}Installing Docker as the infrastructure provider...${NC}"
    clusterctl init --infrastructure docker

    sleep 10
    echo -e "${GREEN}Installing teleport as the identity provider...${NC}"
    sed "s/\$TELEPORT_AUTH_TOKEN/$TELEPORT_AUTH_TOKEN/" docs/0-base-platform/teleport-config.yaml > /tmp/teleport-config.yaml
    sed "s/\$CLUSTER_NAME/platform/" /tmp/teleport-config.yaml > /tmp/teleport-config.yaml
    helm repo add teleport https://charts.releases.teleport.dev
    helm repo update
    helm upgrade --install teleport-agent teleport/teleport-kube-agent -f /tmp/teleport-config.yaml --version 16.4.3 \
--create-namespace --namespace teleport
}

function create_workload_cluster() {
    echo -e "${GREEN}Creating a new development environment ...${NC}"
    clusterctl generate cluster dev --flavor development \
      --kubernetes-version v1.31.0 \
      --control-plane-machine-count=1 \
      --worker-machine-count=1 \
      | kubectl apply -f -

    echo -e "${GREEN}Waiting for the workload cluster to be ready...${NC}"
    kubectl wait --for=condition=Ready cluster/dev --timeout=15m

    HA_PROXY_CONTAINER_NAME="dev-lb"

    # Get the port and host from HA PROXY
    port_mapping=$(docker ps --filter "name=$HA_PROXY_CONTAINER_NAME" --format "{{.Ports}}")
    host_port="https://"$(echo "$port_mapping" | awk -F'->' '{print $1}')
    echo "The HA Proxy for dev cluster is running on port $host_port"

    # Get the kubeconfig file for the dev cluster
    echo "Getting the kubeconfig file for the dev cluster..."
    clusterctl get kubeconfig dev > $KUBECONFIG_DEV_FILE

    # Update the server value in the kubeconfig file
    echo "Updating the server value in the kubeconfig file..."
    yq eval -i '.clusters[] |= select(.name == "dev") .cluster.server = "'"$host_port"'"' "$KUBECONFIG_DEV_FILE"

    sleep 5
    echo -e "${GREEN}Installing the CNI plugin...${NC}"
    kubectl apply --kubeconfig=$KUBECONFIG_DEV_FILE -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml


    sleep 10
    echo -e "${GREEN}Installing teleport as the identity provider...${NC}"
    export TELEPORT_AUTH_TOKEN=$(tctl tokens add --type=kube --format yaml | yq .token)
    sed "s/\$TELEPORT_AUTH_TOKEN/$TELEPORT_AUTH_TOKEN/" docs/0-base-platform/teleport-config.yaml > /tmp/teleport-config-dev-tmp.yaml
    sed "s/\$CLUSTER_NAME/dev/" /tmp/teleport-config-dev-tmp.yaml > /tmp/teleport-config-dev.yaml
    helm upgrade --kubeconfig=$KUBECONFIG_DEV_FILE --install teleport-agent teleport/teleport-kube-agent -f /tmp/teleport-config-dev.yaml --version 16.4.3 \
--create-namespace --namespace teleport
}

function install_flux() {
    echo -e "${GREEN}Installing Flux...${NC}"
    kubectl create ns flux-system
    helm upgrade --install -n flux-system flux oci://ghcr.io/fluxcd-community/charts/flux2

}

function install_crossplane() {
    echo -e "${GREEN}Install Crossplane...${NC}"
    helm upgrade --install crossplane \
      crossplane-stable/crossplane \
      --namespace crossplane-system \
      --create-namespace \
      --set provider.packages='{xpkg.upbound.io/crossplane-contrib/provider-aws:v0.39.0}'

    echo -e "${GREEN}Creating AWS provider secret for Crossplane...${NC}"
    kubectl create secret \
      generic aws-secret \
      -n crossplane-system \
      --from-file=creds=/Users/fernando/.aws/credentials-platform


    echo -e "${GREEN}Deploying the Provider configuration for Crossplane...${NC}"
    kubectl apply -f crossplane/provider-config.yaml
}

function option_four() {
    echo "You selected option 4: Running function for option 4..."
}

function destroy_platform() {
    echo -e "${YELLOW}Destroying the dev cluster...${NC}"
    kubectl delete cluster dev

    echo -e "${YELLOW}Destroying the platform...${NC}"
    kind delete cluster -n platform
}

function show_menu() {
    echo "Please select an option:"
    echo "1) Bootstrap Platform"
    echo "2) Create a workload cluster or development environment"
    echo "3) Install Flux"
    echo "4) Install Crossplane"
    echo "5) Destroy platform"
    echo "6) Exit"
    read -p "Enter your choice [1-6]: " choice
}

# Menu
while true; do
    show_menu
    case $choice in
        1)
            bootstrap_platform
            ;;
        2)
            create_workload_cluster
            ;;
        3)
            install_flux
            ;;
        4)
            install_crossplane
            ;;
        5)
            destroy_platform
            ;;
        6)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option, please try again."
            ;;
    esac
    echo
done
