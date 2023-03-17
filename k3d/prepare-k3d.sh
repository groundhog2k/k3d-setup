#!/bin/bash
echo ">>>>> Bootstrapping K3d"
k3d cluster create $1 -c k3d-default.yaml
echo  "<<<<< K3d ready."
