# Kubernetes no Contexto deste Projeto (EKS com Terraform)

## O que é Kubernetes

Kubernetes (K8s) é uma plataforma de orquestração de containers responsável por automatizar o deploy, escalabilidade, gerenciamento e disponibilidade de aplicações containerizadas.

Neste projeto, o Kubernetes é utilizado através do **Amazon EKS (Elastic Kubernetes Service)**, que fornece o control plane gerenciado pela AWS.

Ou seja:

* A AWS gerencia o control plane
* O Terraform provisiona a infraestrutura
* O cluster executa as aplicações containerizadas

---

## O que é um Cluster Kubernetes

Um **cluster Kubernetes** é o ambiente onde as aplicações são executadas.

Ele é composto por:

### Control Plane (gerenciado pela AWS no EKS)

Responsável por:

* agendamento de pods
* gerenciamento do estado do cluster
* controle de APIs
* controle de nós

No EKS, não precisamos administrar essa camada.

### Worker Nodes

São as máquinas onde os containers realmente executam.

Podem ser:

* EC2 (Node Groups gerenciados)
* Fargate (serverless)

Neste projeto, os nodes serão provisionados via Terraform seguindo boas práticas de modularização.

---

## O que são Pods

O **Pod** é a menor unidade executável dentro do Kubernetes.

Ele representa:

* um container
* ou múltiplos containers que precisam compartilhar contexto

Exemplo:

Uma aplicação backend executando dentro de um container Java roda dentro de um Pod.

---

## O que são Deployments

Deployments são responsáveis por:

* criar pods
* atualizar pods
* garantir alta disponibilidade
* permitir rollback de versões

Eles representam o estado desejado da aplicação.

Exemplo:

Garantir que sempre existam 3 instâncias de uma API rodando.

---

## O que são Services

Pods possuem IP dinâmico.

Por isso usamos **Services**, que criam um endpoint estável para acesso.

Tipos comuns:

* ClusterIP (acesso interno)
* NodePort (acesso via porta do node)
* LoadBalancer (exposição pública via AWS ELB)

Neste projeto utilizaremos principalmente **LoadBalancer** para exposição externa.

---

## O que são Namespaces

Namespaces são divisões lógicas dentro do cluster.

Eles permitem:

* separar ambientes
* organizar aplicações
* controlar permissões

Exemplo comum:

* namespace dev
* namespace staging
* namespace prod

Funcionam de forma semelhante aos **projects do ROSA/OpenShift**.

---

## O que são Node Groups no EKS

Node Groups são grupos de máquinas EC2 que fazem parte do cluster.

Eles permitem:

* escalabilidade automática
* controle de tamanho do cluster
* separação por tipo de workload

Exemplo:

node-group-backend
node-group-jobs
node-group-observability

---

## Como Kubernetes se encaixa neste Projeto

Arquitetura deste projeto:

Terraform provisiona:

* VPC
* Subnets
* IAM
* Security Groups
* Cluster EKS
* Node Groups

Depois disso:

Aplicações serão deployadas no cluster usando manifests Kubernetes ou Helm.

Fluxo esperado:

GitHub → CI/CD → Build imagem → Push ECR → Deploy no EKS

---

## Relação entre Terraform e Kubernetes neste Projeto

Responsabilidades do Terraform:

Criar infraestrutura:

* cluster
* rede
* permissões
* nodes

Responsabilidades do Kubernetes:

Executar aplicações:

* pods
* services
* deployments
* namespaces

Ou seja:

Terraform cria o ambiente
Kubernetes executa o software

---

## Resumo da Arquitetura

Terraform
↓
AWS Infraestrutura
↓
EKS Cluster
↓
Node Groups
↓
Pods
↓
Applications
