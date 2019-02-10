# Download the newes eksctl and install it. 

```
https://github.com/weaveworks/eksctl/releases/
```

# Download AWS IAM Authenticator:
```
curl -o heptio-authenticator-aws https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/darwin/amd64/aws-iam-authenticator
```

# Setup eks cluster
```
eksctl create cluster --name eks-nttdata --nodes 3 --region us-west-2
```

# Install Helm 

```
kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller
```

# Install nginx-ingress controller 

```
helm install stable/nginx-ingress --name micro-nginx-ingress-controller --set rbac.create=true
```

# HOWTO Deploy micro on Kubernetes

```
kubectl apply -f k8s/deployment.yaml
```

## How Kubernetes can pull the Image from AWS

### ECR with AWS managed IAM Policy

```

{
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:BatchGetImage"
            ],
            "Resource": [
                "*"
            ]
}

```

## Port forwarding

Get the container port number

 ```kubectl get pods micro-pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'```

use port-forward to do the port forwarding

```kubectl port-forward micro-pod 6655:8080```

## JX is using network load balancer with nginx-ingress controller

The service for the controller is annotated with  

```service.beta.kubernetes.io/aws-load-balancer-type: nlb```

You can see it using the following command which is using the solution described here: 
https://aws.amazon.com/de/blogs/opensource/network-load-balancer-support-in-kubernetes-1-9/


```kubectl describe svc --namespace=kube-system jxing-nginx-ingress-controller```

* https://blog.fabric8.io/additional-kubernetes-controllers-from-fabric8-you-can-use-with-your-microservice-3126a2c4c132
* https://medium.com/kokster/how-to-setup-nginx-ingress-controller-on-aws-clusters-7bd244278509

## Check nginx configuration

That way you can see the nginx configuration and check if the rules are set correct. 

```
kubectl exec -it jxing-nginx-ingress-controller-86569b6c57-t6d4k -n kube-system cat /etc/nginx/nginx.conf | more
```

## Restart nginx controller

```
kubectl exec -it jxing-nginx-ingress-controller-86569b6c57-t6d4k bash -n kube-system
```

```
nginx -s reload
```

* https://github.com/kubernetes/ingress-nginx/issues/2612



 



