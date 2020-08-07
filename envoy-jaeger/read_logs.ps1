Remove-Item -Recurse -Force ./logs -ErrorAction Ignore

new-item ./logs -itemtype directory

$POD_NAMES = kubectl get pods -l key=owlvey-envoy-pod -o=name -n owlvey

$POD_NAMES | ForEach-Object -Process {    
    $target = ${_}.replace("pod/", "")    
    kubectl cp -n owlvey  ${target}:/tmp/access.log ./logs/access_${target}     
} 
    




