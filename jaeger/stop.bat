kubectl delete -f ./jaegertracing.io_jaegers_crd.yaml

kubectl delete -n owlvey -f ./service_account.yaml
kubectl delete -n owlvey -f ./role.yaml
kubectl delete -n owlvey -f ./role_binding.yaml
kubectl delete -n owlvey -f ./operator.yaml

kubectl delete -f ./cluster_role.yaml
kubectl delete -f ./cluster_role_binding.yaml

kubectl delete -f allinone.yaml 
