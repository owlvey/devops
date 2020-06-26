docker stop registry
TIMEOUT 5
docker rm registry
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

rmdir /Q /S Containers
TIMEOUT 5
rmdir /Q /S Containers
TIMEOUT 5
mkdir Containers

pushd Containers
git clone git@github.com:owlvey/owlvey_falcon.git
rmdir /Q /S "owlvey_falcon/.git"
git clone git@github.com:owlvey/owlvey_identity.git
rmdir /Q /S "owlvey_identity/.git"
git clone git@github.com:owlvey/owlvey_falcon_ui.git
rmdir /Q /S "owlvey_falcon_ui/.git"

popd

python ./local-builder.py

pushd Containers

rem  build.bat

popd

pushd Containers

REM cluster.bat

popd

REM DASHBOARD TOKEN
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | sls admin-user | ForEach-Object { $_ -Split '\s+' } | Select -First 1)