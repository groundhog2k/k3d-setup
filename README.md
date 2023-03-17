# k3d-setup

## What is it good for?

This project will make it very easy to automatically setup a K3d based Kubernetes cluster with one master and three agent nodes on your local development machine with metrics, certificate manager, ingress controller and Kubernetes dashboard.

It supports native Linux and also a WSL2 based setup.

The setup was tested for following environments:

- Ubuntu Linux 22.04
- Debian 11
- Ubuntu Linux 22.04 for WSL2 (MS Windows 10 / 11)
- Debian 11 for WSL2 (MS Windows 10 / 11)

## How to start? (TL;DR)

### Requirements

- Make sure your Linux or WSL2 environment has access to the Internet (directly or via properly configured HTTP/HTTPS proxy)
- You must have Docker installed and accessible from WSL2 by a) having docker services running in WSL2 or b) using Docker for Desktop
- Make sure you have `sudo` permissions
- You need to have `curl` and [helm installed](https://helm.sh/docs/intro/install/) on your Linux environment

### Really.. I want to start it now and create a cluster named `mycluster`

```bash
git clone https://github.com/groundhog2k/k3d-setup.git
cd k3d-setup
./k3d-setup.sh mycluster
```

Install the self-signed root certificate that was generated in `./cluster-system/cert-manager/certs/tls.crt` into your local browser or computer truststore for root certificates.

When setup is finished and all services are running open [https://k8sdash](https://k8sdash) in your browser and enjoy Kubernetes.

**Important - For Windows only:**

Edit the hosts file (typically in [`C:\Windows\system32\drivers\etc\hosts`](C:/Windows/system32/drivers/etc/hosts)) and add a mapping line for the hostname k8sdash:

```text
127.0.0.1 k8sdash
```

## How to stop or (re)-start?

You can stop the installed k3d with:

```bash
k3d cluster stop mycluster
```

...and start it again with:

```bash
k3d cluster start mycluster
```

## How to uninstall?

Uninstall everything related to k3s with a simple:

```bash
k3d cluster delete mycluster
```

---

## Give me the details

### For Linux and WSL2

For Linux and WSL2 it will simply install K3d and prepare a few more services like, metrics server, Jetstack certificate manager, Ingress nginx and Kubernetes dashboard.

### All the scripts in detail

The script `k3d-setup.sh [name]` builds the bracket around a few other scripts.
It will call the following sub-scripts:

1. `k3s/prepare-k3d.sh [name]`

    The script will take the optional name (default: `cluster`) and the template file k3d-default.yaml to deploy a k3d cluster in docker.
    K3d is using docker to start the nodes as containers with nested K3s.

    Take a look at the `k3d-default.yaml` to change the number of master and agent nodes or customize other [k3d options](https://k3d.io/v5.0.1/usage/configfile/).

2. `cluster-system/cluster-setup.sh`

   This sub-script creates a namespace `cluster-system`. All following custom cluster-wide components will be deployed to this namespace via helm charts.

   1. `cluster-system/metrics-server/install.sh`

      Installs the Kubernetes metrics-server from the [original helm chart](https://github.com/kubernetes-sigs/metrics-server).

   2. `cluster-system/cert-manager/install.sh`

      The script generates a self-signed root certificate (if not already existend in the [`certs`](https://github.com/groundhog2k/k3s-setup/tree/main/cluster-system/cert-manager/certs) folder) and deploys this together with the [Jetstack cert-manager](https://github.com/cert-manager/cert-manager).

   3. `cluster-system/ingress-nginx/install.sh`

      Deploys the [Ingress-nginx](https://github.com/kubernetes/ingress-nginx) service as Kubernetes Ingress Controller.

   4. `cluster-system/k8s-dashboard/install.sh`

      This scripts deploys the [Kubernetes dashboard](https://github.com/kubernetes/dashboard) management UI from the original helm chart.

      Together with the Ingress component from previous step the UI should appear for the local URI [https://k8sdash](https://k8sdash)

      **Important:**

      **Install the self-signed root certificate into your local browser or computer truststore for root certificates.**
