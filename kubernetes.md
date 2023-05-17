# Ref

* [cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

# Tools

* [k3d](https://k3d.io/v5.0.0/)
* [k3s](https://k3s.io/)
* [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
* [stern](https://github.com/stern/stern)

# Commands and experimentation

Rollout all deployment in all namespaces
```kubectl get -A deploy --output custom-columns=name:.metadata.name,namespace:.metadata.namespace --no-headers \                                                           
| xargs -l bash -c 'kubectl rollout restart deployments -n $2 $1'```
