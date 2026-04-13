# EKS IaC com Terraform e Kubernetes

## Visão geral

Este projeto implementa uma infraestrutura AWS para Amazon EKS usando Terraform, com deploy de uma aplicação NGINX em Kubernetes e exposição pública via Service do tipo `LoadBalancer`.

Ele cobre:

* Provisionamento da VPC e redes públicas
* Criação de funções IAM para EKS e worker nodes
* Provisionamento de cluster EKS e managed node group
* Deploy de `nginx` no Kubernetes
* Exposição pública com `Service` LoadBalancer

---

## Estrutura do projeto

- `environments/dev/`
  - `backend.tf` - backend do Terraform (atualmente vazio)
  - `main.tf` - ambiente de deploy que orquestra os módulos
  - `provider.tf` - provider AWS configurado para `sa-east-1`
  - `terraform.tfstate` / `terraform.tfstate.backup` - estado local existente
  - `terraform.tfvars` - variáveis de ambiente (não há conteúdo relevante no repositório)
  - `variables.tf` - arquivo de variáveis do ambiente (atualmente vazio)
- `modules/vpc/` - criação de VPC, subnets públicas, internet gateway, route table e associações
- `modules/iam/` - criação de roles IAM para cluster EKS e worker nodes
- `modules/eks/` - criação do cluster EKS
- `modules/node-group/` - criação de EKS Managed Node Group
- `k8s/` - manifests Kubernetes para `nginx` e serviço `LoadBalancer`
- `elb-policy/iam_policy.json` - política IAM auxiliar armazenada no repositório

---

## Componentes principais

### VPC

O módulo `modules/vpc` cria:

- `aws_vpc` com CIDR `10.0.0.0/16`
- `aws_subnet.public` em 2 AZs (`sa-east-1a`, `sa-east-1b`)
- `aws_internet_gateway`
- `aws_route_table` com rota para `0.0.0.0/0`
- associações de subnet com a route table pública

### IAM

O módulo `modules/iam` cria duas roles:

- `eks_cluster_role` com `AmazonEKSClusterPolicy`
- `node_role` com políticas:
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEKS_CNI_Policy`
  - `AmazonEC2ContainerRegistryReadOnly`

### EKS Cluster

O módulo `modules/eks` cria o cluster EKS em subnets públicas usando:

- `cluster_name` = `miura-cluster`
- `role_arn` do módulo `iam`
- `subnet_ids` do módulo `vpc`

Também exporta:

- `cluster_name`
- `cluster_endpoint`
- `cluster_ca`

### Node Group

O módulo `modules/node-group` cria um managed node group com:

- `instance_types = ["t3.small"]`
- `min_size = 1`, `desired_size = 1`, `max_size = 2`
- `node_role_arn` do módulo IAM
- `subnet_ids` do módulo VPC

### Kubernetes manifests

O diretório `k8s/` contém:

- `nginx-deployment.yaml` - Deployment `nginx` com 1 réplica
- `nginx-service.yaml` - Service `LoadBalancer` expondo porta 80
- `nginx-ingress.yaml` - manifest de Ingress presente no repositório

---

## Como usar

### Pré-requisitos

- AWS CLI configurado com credenciais válidas
- Terraform instalado
- kubectl configurado (após criação do cluster)

### Passos

1. Navegue para o ambiente de deploy:

   ```bash
   cd environments/dev
   ```

2. Inicialize o Terraform:

   ```bash
   terraform init
   ```

3. Aplique a infraestrutura:

   ```bash
   terraform apply
   ```

4. Após a criação do cluster, configure `kubectl` usando `aws eks update-kubeconfig` ou via outputs do módulo EKS.

5. Aplique os manifests Kubernetes:

   ```bash
   kubectl apply -f ../../k8s/nginx-deployment.yaml
   kubectl apply -f ../../k8s/nginx-service.yaml
   ```

6. Verifique o Service e acesse o endpoint publicamente:

   ```bash
   kubectl get svc nginx-service
   kubectl get pods
   ```

---

## Observações importantes

- O ambiente está configurado para `sa-east-1` no `environments/dev/provider.tf`.
- `backend.tf` está vazio no ambiente `dev`, portanto o estado está sendo mantido localmente.
- O cluster EKS está usando subnets públicas, o que expõe o ELB publicamente.
- O `terraform.tfvars` não contém variáveis padronizadas no repositório.

---

## Melhorias possíveis

- configurar backend remoto (S3 + DynamoDB)
- separar subnets públicas e privadas
- habilitar autoscaling e node groups adicionais
- adicionar `aws-auth` ConfigMap ou módulo para RBAC mais robusto
- incluir um Ingress Controller e TLS
- adicionar outputs de `kubeconfig` e load balancer URL

---

## Resumo do fluxo

1. `terraform apply` provisiona a VPC, IAM, EKS e worker nodes.
2. `kubectl apply` provisiona o Deployment e Service NGINX.
3. O Service `nginx-service` cria um Load Balancer AWS e expõe o NGINX publicamente.

---

## Arquivos de destaque

- `environments/dev/main.tf`
- `modules/vpc/main.tf`
- `modules/iam/main.tf`
- `modules/eks/main.tf`
- `modules/node-group/main.tf`
- `k8s/nginx-deployment.yaml`
- `k8s/nginx-service.yaml`

---