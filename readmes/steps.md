1 - aws eks update-kubeconfig \
--name miura-cluster \
--region sa-east-1

2 -  kubectl get nodes


3 - kubectl apply -f k8s/nginx-deployment.yaml

4 - kubectl get pods


--- Exposição via ELB ---

kubectl apply -f k8s/nginx-service.yaml

kubectl get svc

pegue o externai IP e jogue no navegado, espere uns 5 minutos
http://<EXTERNAL-IP>.com



--- eksctl ---

1 - curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" \
| tar xz -C /tmp


2 - sudo mv /tmp/eksctl /usr/local/bin

--- LOAD BALANCER ---

1 - policy
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

2 - aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json

3 - 
eksctl utils associate-iam-oidc-provider \
  --region sa-east-1 \
  --cluster miura-cluster \
  --approve

4 - eksctl create iamserviceaccount \
  --cluster=miura-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::954976305765:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve


 ---  HELM -- 


 1 - helm repo add eks https://aws.github.io/eks-charts

 2 - helm repo update


 3- helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=miura-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=sa-east-1 \
  --set vpcId=$(aws eks describe-cluster \
    --name miura-cluster \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)


--- INgress -- 

1 - kubectl apply -f k8s/nginx-ingress.yaml
