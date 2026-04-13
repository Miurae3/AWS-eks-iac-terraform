# README 1 — Projeto: Deploy de Aplicação no Amazon EKS com Exposição via Service LoadBalancer

## 📌 Visão Geral

Este projeto demonstra a criação de um cluster Kubernetes utilizando Amazon EKS e a exposição de uma aplicação para acesso público via Service do tipo LoadBalancer. O objetivo foi construir uma base prática e alinhada com arquitetura real de mercado, cobrindo desde a criação do cluster até a disponibilização da aplicação na internet.

A proposta do projeto foi validar conceitos essenciais de:

* Provisionamento de cluster Kubernetes gerenciado
* Configuração de acesso IAM + RBAC
* Deploy de workloads
* Exposição de serviços
* Integração com Load Balancer da AWS
* Troubleshooting comum em ambientes EKS

---

## 🏗 Arquitetura do Projeto

Fluxo da aplicação:

Internet
↓
AWS Load Balancer (provisionado automaticamente)
↓
Service (LoadBalancer)
↓
Deployment
↓
Pods (NGINX)

O Service do tipo LoadBalancer realiza integração automática com a AWS e provisiona um endpoint público.

---

## ⚙️ Tecnologias Utilizadas

* Amazon EKS
* Kubernetes
* kubectl
* AWS CLI
* IAM
* VPC
* EC2 Worker Nodes
* NGINX (container de teste)

---

## 🚀 Etapas Executadas no Projeto

### 1️⃣ Criação do cluster EKS

Foi criado um cluster Kubernetes gerenciado pela AWS com worker nodes configurados automaticamente.

Principais recursos envolvidos:

* VPC
* Subnets públicas
* Security Groups
* Node Group
* IAM Roles

---

### 2️⃣ Configuração de acesso ao cluster

Após a criação do cluster, foi necessário ajustar o acesso RBAC utilizando o ConfigMap aws-auth.

Esse passo permitiu:

* acesso administrativo via kubectl
* visualização dos workloads no console AWS
* gerenciamento completo do cluster

---

### 3️⃣ Deploy da aplicação NGINX

Foi criado um Deployment Kubernetes contendo pods com container NGINX:

kubectl create deployment nginx-deployment --image=nginx

Posteriormente validado com:

kubectl get pods

---

### 4️⃣ Exposição da aplicação via Service LoadBalancer

A aplicação foi exposta publicamente utilizando:

kubectl expose deployment nginx-deployment 
--type=LoadBalancer 
--port=80 
--target-port=80 
--name=nginx-service

Esse comando provisionou automaticamente:

* AWS Elastic Load Balancer
* endpoint público
* integração com networking do cluster

Permitindo acesso externo via navegador 🌐

---

## 🔍 Validações Realizadas

Durante o projeto foram validados:

* funcionamento do cluster
* comunicação entre pods
* criação automática do Load Balancer
* integração Kubernetes + AWS
* acesso público externo

---

## 🧠 Principais Aprendizados

Entre os principais aprendizados obtidos:

* funcionamento da autenticação IAM no EKS
* integração entre RBAC e aws-auth ConfigMap
* arquitetura de exposição via Service LoadBalancer
* troubleshooting de permissões
* provisionamento automático de recursos AWS pelo Kubernetes

---

## 📦 Resultado Final

Ao final do projeto foi possível:

✔ Criar cluster EKS funcional
✔ Realizar deploy de aplicação containerizada
✔ Expor aplicação publicamente
✔ Validar integração entre Kubernetes e AWS
✔ Estruturar arquitetura compatível com ambiente real

Este projeto serve como base sólida para evoluções futuras como:

* Ingress Controller
* TLS com ACM
* CI/CD
* ExternalDNS
* Observabilidade
