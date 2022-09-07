echo OTOT A2 SCRIPT
echo -------------------------
echo Creating Cluster!
kind create cluster --name kind-1 --config kind/cluster-config.yaml

kubectl cluster-info --context kind-kind-1
kubectl get nodes --context kind-kind-1

echo Creating Deployment!
kubectl apply -f manifests/k8s/backend-deployment.yaml --context kind-kind-1
kind load docker-image blaketingyu/a1_app --name kind-1

kubectl wait --for=condition=ready pod --selector=app=backend --timeout=180s --context kind-kind-1
kubectl get po -l app=backend -o wide --context kind-kind-1

echo Creating Service!
kubectl apply -f manifests/k8s/service.yaml --context kind-kind-1

kubectl describe svc backend-service --context kind-kind-1
kubectl get svc -l app=backend -o wide --context kind-kind-1

echo Creating Ingress Controller!
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml --context kind-kind-1

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s --context kind-kind-1
kubectl --namespace ingress-nginx get po -l app.kubernetes.io/component=controller -o wide --context kind-kind-1
kubectl -n ingress-nginx get deploy --context kind-kind-1

echo Creating Ingress!
kubectl apply -f manifests/k8s/ingress.yaml --context kind-kind-1

kubectl get ingress -l app=backend -o wide --context kind-kind-1

#Curling right away has issues
sleep 15

echo Is curl successful
curl localhost/


echo Script Finished Running!