# https://www.tecmint.com/tcpflow-analyze-debug-network-traffic-in-linux/
# https://hub.docker.com/r/byfcz/tcpflow/
Remove-Item -Recurse -Force ./trace/*

$target = "owlvey-backend-local-deployment"
$namespace = "owlvey"
kubectl scale deployment ${target} -n ${namespace} --replicas=1
Start-Sleep -s 20

write-host  "kubectl describe deployments -n ${namespace} ${target}"

# kubectl patch deployment ${target} -n ${namespace} --patch $(Get-Content patch-tempdump.yaml -Raw)
kubectl patch deployment ${target} -n ${namespace} --patch $(Get-Content patch-tcpflow.yaml -Raw)
Start-Sleep -s 20

$POD_NAME = kubectl get pods -l key=owlvey-api-pod --field-selector status.phase=Running -o=name  -n ${namespace}
$POD_NAME = $POD_NAME.replace("pod/", "")
write-host "kubectl attach -it ${POD_NAME} -n ${namespace} -c tcpflowcontainer" 
write-host "kubectl logs -n ${namespace}  ${POD_NAME}"


Start-Sleep -s 60

kubectl cp -c tcpflowcontainer ${namespace}/${POD_NAME}:app ./trace 


