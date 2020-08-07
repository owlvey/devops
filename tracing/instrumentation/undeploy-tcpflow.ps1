$target = "owlvey-backend-local-deployment"
$namespace = "owlvey"
kubectl rollout undo deployment/${target} -n ${namespace}