kubectl apply -f ./envoy.yaml 
kubectl apply -f ./deploy-zipkin.yaml 

kubectl get pods -n owlvey

$target_zipkin = kubectl get pods -l key=owlvey-zipkin-pod -n owlvey -o name

$target_zipkin = $target_zipkin.replace("pod/", "")
write-host ""
write-host "kubectl port-forward -n owlvey ${target_zipkin} 9411"
write-host ""

Start-Sleep -s 5

$target = kubectl get pods -l key=owlvey-envoy-pod -n owlvey -o name
$target = $target.replace("pod/", "")

write-host ""
write-host "kubectl port-forward -n owlvey ${target} 9901"
write-host ""

kubectl port-forward $target -n owlvey 10000:10000