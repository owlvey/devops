

$target = "owlvey-backend-local-deployment"
$namespace = "owlvey"
kubectl scale deployment ${target} -n ${namespace} --replicas=1


kubectl get deploy ${target} -n ${namespace} -o yaml | Out-File -Encoding utf8 -FilePath ./backup.yaml

kubectl apply -f ./deploy-toxic.yaml

$POD_NAMES = kubectl get pods -l key=owlvey-api-pod -o name -n owlvey

$POD_NAMES | ForEach-Object -Process {    
    kubectl delete  ${_} -n owlvey 
} 

kubectl get pods -n owlvey -l key=chaos-toxi-pod

# kubectl exec -it -n owlvey chaos-toxi-deployment-55d475cb59-88dhp -- sh