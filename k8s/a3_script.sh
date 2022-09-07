echo OTOT A3 SETUP
echo ==========================

echo Creating clusters!
kind create cluster --name kind-1 --config kind/cluster-config.yaml

kubectl cluster-info --context kind-kind-1
kubectl get nodes --context kind-kind-1

echo Creating deployment!
kind load docker-image blaketingyu/a1_app --name kind-1

echo Starting up metrics server!
kubectl apply -f manifests/k8s/metrics-server.yaml --context kind-kind-1
kubectl wait -nkube-system --for=condition=ready pod --selector=k8s-app=metrics-server --timeout=180s --context kind-kind-1
kubectl -nkube-system --selector=k8s-app=metrics-server get deploy --context kind-kind-1

echo Starting auto scaling hpa!
kubectl apply -f manifests/k8s/backend-hpa.yaml --context kind-kind-1
kubectl describe hpa --context kind-kind-1

echo Script Finished Running!
