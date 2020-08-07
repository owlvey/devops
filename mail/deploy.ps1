
kubectl create namespace mailing

kubectl apply -f .\deploy-mail.yaml
kubectl apply -f .\service-mail.yaml
kubectl apply -f .\route-mail.yaml

kubectl get pods -n mailing