echo Removing all A3.2 Stuffs
echo ==========================

echo Deleteing ingress!
kubectl delete ingress backend-ingress-zone-aware

echo Deleteing ingress controller!
kubectl delete -n ingress-nginx deploy ingress-nginx-controller

echo Deleting service!
kubectl delete service backend-service-zone-aware

echo Deleteing deployment!
kubectl delete deploy backend-zone-aware

echo Deleting cluster!
kind delete cluster --name kind-1

echo Script Finished Running!