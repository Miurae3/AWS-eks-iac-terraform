# README 1 — Projeto: Deploy de Aplicação no Amazon EKS com Provisionamento via Terraform e Exposição Pública

## 📌 Visão Geral

Este projeto demonstra a criação de uma infraestrutura completa Kubernetes na AWS utilizando Amazon EKS com provisionamento via Terraform e deploy de aplicação exposta publicamente utilizando Service do tipo LoadBalancer.

O objetivo foi construir uma arquitetura realista baseada em práticas utilizadas em ambientes corporativos, cobrindo:

* criação da infraestrutura com Terraform
* provisionamento do cluster EKS
* configuração de acesso IAM + RBAC
* deploy de aplicação containerizada
* exposição pública via LoadBalancer
* troubleshooting de autenticação e networking

---

## 🏗 Arquitetura do Projeto

Fluxo da aplicação:

Internet
↓
AWS Load Balancer (provisionado automaticamente pelo Kubernetes)
↓
Service (LoadBalancer)
↓
Deployment
↓
Pods (NGINX)

Provisionamento da infraestrutura:

Terraform
↓
VPC
↓
Subnets públicas
↓
Security Groups
↓
IAM Roles
↓
EKS Cluster
↓
Node Group

---

## ⚙️ Tecnologias Utilizadas

* Terraform
* Amazon EKS
* Kubernetes
* kubectl
* AWS CLI
* IAM
* VPC
* EC2 Managed Node Group
* NGINX

---

## 📂 Estrutura do Projeto

O projeto foi organizado seguindo separação lógica de responsabilidades:

infraestrutura/
→ criação da VPC
→ subnets públicas
→ security groups
→ roles IAM

cluster/
→ criação do cluster EKS
→ node group

k8s/
→ deployment nginx
→ service LoadBalancer

Essa separação facilita reutilização, manutenção e evolução da arquitetura.

---

## 🚀 Etapas Executadas no Projeto

### 1️⃣ Provisionamento da infraestrutura base

Utilizando Terraform foram criados:

* VPC dedicada
* subnets públicas
* security groups
* roles IAM

Esses recursos formam a base necessária para execução do cluster EKS.

---

### 2️⃣ Criação do cluster EKS

Cluster provisionado com:

* endpoint público
* managed node group
* integração IAM

Garantindo ambiente Kubernetes gerenciado pela AWS.

---

### 3️⃣ Configuração de acesso ao cluster

Foi necessário configurar autorização Kubernetes via ConfigMap aws-auth.

Esse passo permitiu:

* acesso administrativo via kubectl
* acesso ao console EKS Workloads
* gerenciamento completo do cluster

---

### 4️⃣ Deploy da aplicação NGINX

Deployment criado com:

kubectl create deployment nginx-deployment --image=nginx

Validação:

kubectl get pods

---

### 5️⃣ Exposição pública da aplicação

Service criado com:

kubectl expose deployment nginx-deployment 
--type=LoadBalancer 
--port=80 
--target-port=80 
--name=nginx-service

Provisionamento automático realizado:

* Elastic Load Balancer
* endpoint público
* integração com networking AWS

Aplicação acessível via internet.

---

## 🔍 Troubleshooting Realizado

Durante o projeto foram resolvidos cenários comuns de ambientes EKS:

* erro de acesso ao console Workloads
* ajuste do aws-auth ConfigMap
* validação RBAC
* validação criação automática do LoadBalancer

Esses cenários representam situações reais encontradas em projetos corporativos.

---

## 🧠 Principais Aprendizados

Principais conceitos consolidados:

* integração IAM + RBAC no EKS
* arquitetura Service LoadBalancer
* provisionamento automatizado via Terraform
* integração Kubernetes com serviços AWS
* debugging de permissões

---

## 📦 Resultado Final

Ao final do projeto foi possível:

✔ Provisionar infraestrutura com Terraform
✔ Criar cluster EKS funcional
✔ Realizar deploy containerizado
✔ Expor aplicação publicamente
✔ Validar integração Kubernetes + AWS

Arquitetura pronta para evoluções futuras:

* Ingress Controller
* TLS com ACM
* CI/CD automatizado
* Observabilidade

# README 2 — Post Técnico (Formato LinkedIn)

## 🚀 Projeto prático: Deploy de aplicação no Amazon EKS com exposição pública

Recentemente desenvolvi um projeto prático focado em Kubernetes na AWS utilizando Amazon EKS com provisionamento de infraestrutura via Terraform.

O objetivo foi implementar o fluxo completo:

infraestrutura → cluster → workload → exposição pública

Durante o projeto trabalhei com:

* criação de VPC via Terraform
* provisionamento de cluster EKS
* configuração IAM + RBAC
* deploy de aplicação NGINX
* exposição pública via Service LoadBalancer

Arquitetura construída:

Internet
↓
AWS Load Balancer
↓
Service (LoadBalancer)
↓
Deployment
↓
Pods

Um dos principais aprendizados foi entender na prática a separação entre autenticação IAM e autorização RBAC dentro do EKS.

Outro ponto importante foi validar como o Kubernetes consegue provisionar automaticamente recursos externos na AWS apenas com objetos declarativos.

Principais desafios enfrentados:

* ajuste do aws-auth ConfigMap
* configuração RBAC
* validação de acesso ao console EKS
* entendimento do fluxo de exposição pública

Resultado final:

Aplicação containerizada publicada com sucesso utilizando LoadBalancer provisionado automaticamente pela AWS.

Esse projeto reforçou conceitos fundamentais de:

* Kubernetes networking
* integração com cloud provider
* provisionamento via Terraform

Próximos passos naturais dessa arquitetura incluem:

* Ingress Controller
* TLS com ACM
* pipeline CI/CD
* observabilidade com métricas e logs

Projetos como esse ajudam a consolidar experiência prática com arquitetura cloud-native utilizada em ambientes reais.
