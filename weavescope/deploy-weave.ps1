kubectl apply -f .\deploy-weavescope.yaml

Start-Sleep -s 20

kubectl get pods -n weave -o wide


#  kubectl port-forward weave-scope-app-bc7444d59-86wdw -n weave 4040