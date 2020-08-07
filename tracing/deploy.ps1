kubectl create namespace tracing

kubectl apply -f ./deploy-jaeger.yaml
kubectl apply -f ./deploy-zipkin.yaml


Start-Sleep -s 5

kubectl get pods -n tracing
kubectl get services -n tracing
kubectl get endpoints -n tracing