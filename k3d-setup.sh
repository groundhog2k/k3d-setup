#!/bin/bash
# Bootstrap a K3d based Kubernetes setup with metrics, ingress, cert-manager and K8s dashboard

## 0. Install latest k3d first
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

## 1. Bootstrap K3d
clustername=${1:-cluster}
cd k3d
./prepare-k3d.sh $clustername

## 2. Prepare cluster services
cd ../cluster-system
./cluster-setup.sh

echo "*** Finished! Enjoy your local K8d environment. ***"
