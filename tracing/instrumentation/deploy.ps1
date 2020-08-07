Remove-Item -Recurse -Force ./trace/*

$target = "owlvey-backend-local-deployment"
$namespace = "owlvey"
kubectl scale deployment ${target} -n ${namespace} --replicas=1
Start-Sleep -s 20


write-host  "kubectl describe deployments -n ${namespace} ${target}"

# kubectl patch deployment ${target} -n ${namespace} --patch $(Get-Content patch-tempdump.yaml -Raw)
kubectl patch deployment ${target} -n ${namespace} --patch $(Get-Content patch-tcpflow.yaml -Raw)
Start-Sleep -s 5

$POD_NAME = kubectl get pods -l key=owlvey-api-pod --field-selector status.phase=Running -o=name  -n ${namespace}
$POD_NAME = $POD_NAME.replace("pod/", "")

write-host "kubectl attach -it ${POD_NAME} -n ${namespace}"

Start-Sleep -s 20

# kubectl /tcpdump/myapp.pcap
kubectl cp -c tcpdumper ${namespace}/${POD_NAME}:/tcpdump ./trace 

push-location trace

tshark -r ./tcpdump.pcap --export-objects "http,response_bodies"

tshark -r ./tcpdump.pcap -i http==1 -O http -T fields -e http.request.method -e http.request.uri -e http.request.line > dump_headers.txt

Pop-Location 