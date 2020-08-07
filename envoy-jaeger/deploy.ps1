kubectl apply -f envoy.yaml 
kubectl apply -f deploy-envoy.yaml 

Start-Sleep -s 7

$target = kubectl get pods -l key=owlvey-envoy-pod -n owlvey -o name

$target = $target.replace("pod/", "")

write-host $target
kubectl get pods -n owlvey 


$target_jaeger = kubectl get pods -l key=owlvey-jaeger-pod -n owlvey -o name
$target_jaeger = $target_jaeger.replace("pod/", "")
write-host ""
write-host "kubectl port-forward -n owlvey ${target_jaeger} 16686"
write-host ""
kubectl port-forward $target -n owlvey 10000:10000