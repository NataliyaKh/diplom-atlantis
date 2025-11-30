#!/bin/bash
set -e

echo "=== Applying Manifests ==="

echo "Temporarily disabling ingress-nginx webhooks..."
kubectl delete validatingwebhookconfiguration ingress-nginx-admission --ignore-not-found || true
kubectl delete mutatingwebhookconfiguration ingress-nginx-admission --ignore-not-found || true

echo "Applying Ingress Nginx..."
kubectl apply -k manifests/ingress-nginx/

echo "Waiting for Ingress Nginx to be ready..."

echo "Waiting for resources to be created..."
sleep 30

echo "Checking created resources in ingress-nginx namespace:"
kubectl get all -n ingress-nginx || echo "No resources found"

echo "Waiting for any pod to be ready..."
INGRESS_READY=false
for i in {1..24}; do
    POD_COUNT=$(kubectl get pods -n ingress-nginx --field-selector=status.phase=Running --no-headers 2>/dev/null | wc -l || echo "0")
    if [ "$POD_COUNT" -gt 0 ]; then
        INGRESS_READY=true
        echo "Found $POD_COUNT running pod(s) in ingress-nginx namespace"
        break
    fi
    echo "Waiting for pods... ($i/24)"
    sleep 5
done

if [ "$INGRESS_READY" = false ]; then
    echo "No running pods found in ingress-nginx namespace after waiting"
    echo "Current pod status:"
    kubectl get pods -n ingress-nginx 2>/dev/null || echo "No pods found"
fi

echo "Applying other manifests..."

if [ -d "manifests/network-policies" ]; then
    echo "Applying Network Policies..."
    kubectl apply -k manifests/network-policies/
fi

if [ -d "manifests/ingress" ]; then
    echo "Applying Ingress resources..."
    kubectl apply -k manifests/ingress/
fi

echo "All manifests applied successfully"
