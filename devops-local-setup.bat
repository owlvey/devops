docker stop registry
TIMEOUT 5
docker rm registry

docker container prune -f 
docker image prune -a -f 
TIMEOUT 5
docker run -d -p 48700:5000 --restart=always --name registry registry:latest
TIMEOUT 5
kubectl delete -f ./gateway/gateway-install.yaml
TIMEOUT 5
kubectl apply -f ./gateway/gateway-install.yaml
TIMEOUT 5
kubectl delete -f ./dashboard/deploy-admin.yaml

kubectl delete namespace kubernetes-dashboard
TIMEOUT 5
kubectl create namespace kubernetes-dashboard
kubectl apply -f ./dashboard/deploy-dashboard.yaml
kubectl apply -f ./dashboard/deploy-admin.yaml
kubectl apply -f ./dashboard/route-dashboard.yaml

TIMEOUT 5

kubectl delete namespace monitoring
kubectl create namespace monitoring
kubectl apply -f ./prometheus/configmap.yaml
kubectl apply -f ./prometheus/rbas-prometheus.yaml
kubectl apply -f ./prometheus/deploy-prometheus.yaml
kubectl apply -f ./prometheus/service-prometheus.yaml
kubectl apply -f ./prometheus/route-prometheus.yaml

rmdir /Q /S cluster 
TIMEOUT 5
rmdir /Q /S cluster 
TIMEOUT 5
mkdir cluster 