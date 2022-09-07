echo OTOT A3.2 SETUP
echo ==========================

echo Creating clusters!
kind create cluster --name kind-1 --config kind/cluster-config.yaml

kubectl cluster-info --context kind-kind-1
kubectl get nodes --context kind-kind-1

echo Creating deployment!
kind load docker-image blaketingyu/a1_app --name kind-1
kubectl apply -f manifests/k8s/backend-service-zone-aware.yaml --context kind-kind-1

kubectl wait --for=condition=ready pod --selector=app=backend-zone-aware --timeout=180s --context kind-kind-1
kubectl get po -l app=backend-zone-aware -o wide --context kind-kind-1

echo Creating service!
kubectl apply -f manifests/k8s/service-zone-aware.yaml --context kind-kind-1

kubectl describe svc backend-service-zone-aware --context kind-kind-1
kubectl get svc -l app=backend-zone-aware -o wide --context kind-kind-1

echo Creating ingress controller!
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-kind-1

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s --context kind-kind-1
kubectl --namespace ingress-nginx get po -l app.kubernetes.io/component=controller -o wide --context kind-kind-1
kubectl -n ingress-nginx get deploy --context kind-kind-1

echo Creating ingress!
kubectl apply -f manifests/k8s/ingress-zone-aware.yaml --context kind-kind-1

kubectl get ingress -l app=backend-zone-aware -o wide --context kind-kind-1

#Curling right away has issues
sleep 15

echo Is curl successful?
curl localhost/

kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName' --context kind-kind-1

echo Script Finished Running!
