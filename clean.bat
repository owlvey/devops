kubectl delete -f ./gateway/gateway-install.yaml


kubectl delete -f ./prometheus/configmap.yaml
kubectl delete -f ./prometheus/rbas-prometheus.yaml
kubectl delete -f ./prometheus/deploy-prometheus.yaml
kubectl delete -f ./prometheus/service-prometheus.yaml
kubectl delete -f ./prometheus/route-prometheus.yaml


kubectl delete -f ./grafana/config-grafana.yaml
kubectl delete -f ./grafana/deploy-grafana.yaml
kubectl delete -f ./grafana/service-grafana.yaml
kubectl delete -f ./grafana/route-grafana.yaml


kubectl delete -f ./dashboard/deploy-admin.yaml
kubectl delete namespace kubernetes-dashboard

kubectl delete -f ./metricserver/deploy-metricserver.yaml
