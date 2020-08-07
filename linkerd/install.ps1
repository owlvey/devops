# unicode 
# CMD /U 
./linkerd.exe install | kubectl apply -f -

 Start-Sleep -s 3

 ./linkerd.exe check

kubectl get -n owlvey deploy -o yaml | Out-File -Encoding utf8 -FilePath ./owlvey.yaml

./linkerd inject  ./owlvey.yaml  | Out-File -FilePath ./inject_owlvey.yaml

kubectl apply -f ./inject_owlvey.yaml

./linkerd -n owlvey check --proxy
./linkerd -n owlvey stat deploy
# ./linkerd -n owlvey top deploy
# ./linkerd -n owlvey  tap deploy/owlvey-backend-local-deployment
./linkerd dashboard &


