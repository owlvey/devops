kubectl apply -f deploy-db2.yaml
Start-Sleep -s 10
kubectl logs -l key=db2-pod -n sample
Start-Sleep -s 20
$POD_NAME = kubectl get pods -l key=db2-pod -o name -n owlvey
$POD_NAME = $POD_NAME.replace("pod/", "")

kubectl exec -it  ${POD_NAME}  -n sample -- /bin/bash