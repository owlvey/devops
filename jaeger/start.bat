kubectl apply -f ./jaegertracing.io_jaegers_crd.yaml

kubectl create -n owlvey -f ./service_account.yaml
kubectl create -n owlvey -f ./role.yaml
kubectl create -n owlvey -f ./role_binding.yaml
kubectl create -n owlvey -f ./operator.yaml

kubectl create -f ./cluster_role.yaml
kubectl create -f ./cluster_role_binding.yaml

kubectl get deployment jaeger-operator -n owlvey

kubectl apply -f allinone.yaml -n owlvey


kubectl get jaegers -n owlvey
kubectl get pods  -n owlvey
