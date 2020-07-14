docker stop registry
TIMEOUT 5
docker rm registry

docker container prune -f 

docker image prune -a -f 

TIMEOUT 3
docker run -d -p 48700:5000 --restart=always --name registry registry:latest
TIMEOUT 3

kubectl apply -f ./metricserver/deploy-metricserver.yaml

TIMEOUT 3
kubectl delete -f ./gateway/gateway-install.yaml

TIMEOUT 3
kubectl apply -f ./gateway/gateway-install.yaml

TIMEOUT 3
kubectl delete -f ./dashboard/deploy-admin.yaml
kubectl delete namespace kubernetes-dashboard

TIMEOUT 3
kubectl create namespace kubernetes-dashboard
kubectl apply -f ./dashboard/deploy-dashboard.yaml
kubectl apply -f ./dashboard/deploy-admin.yaml
kubectl apply -f ./dashboard/route-dashboard.yaml

TIMEOUT 3
kubectl delete namespace monitoring

TIMEOUT 3
kubectl create namespace monitoring


kubectl delete -f ./prometheus/configmap.yaml
kubectl delete -f ./prometheus/rbas-prometheus.yaml
kubectl delete -f ./prometheus/deploy-prometheus.yaml
kubectl delete -f ./prometheus/service-prometheus.yaml
kubectl delete -f ./prometheus/route-prometheus.yaml

kubectl apply -f ./prometheus/configmap.yaml
kubectl apply -f ./prometheus/rbas-prometheus.yaml
kubectl apply -f ./prometheus/deploy-prometheus.yaml
kubectl apply -f ./prometheus/service-prometheus.yaml
kubectl apply -f ./prometheus/route-prometheus.yaml

kubectl delete -f ./grafana/config-grafana.yaml
kubectl delete -f ./grafana/deploy-grafana.yaml
kubectl delete -f ./grafana/service-grafana.yaml
kubectl delete -f ./grafana/route-grafana.yaml

kubectl apply -f ./grafana/config-grafana.yaml
kubectl apply -f ./grafana/deploy-grafana.yaml
kubectl apply -f ./grafana/service-grafana.yaml
kubectl apply -f ./grafana/route-grafana.yaml


rmdir /Q /S cluster 
mkdir cluster 


pushd cluster 
git clone --branch develop git@github.com:owlvey/owlvey_falcon.git
rmdir /Q /S "owlvey_falcon/.git"
git clone --branch develop git@github.com:owlvey/owlvey_identity.git
rmdir /Q /S "owlvey_identity/.git"
git clone --branch develop git@github.com:owlvey/owlvey_falcon_ui.git
rmdir /Q /S "owlvey_falcon_ui/.git"

popd

python ./local-builder.py

pushd cluster 

rem  build.bat

popd

pushd cluster 

REM cluster.bat

popd
