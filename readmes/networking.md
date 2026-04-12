# Fase 6 — Kubernetes Networking (Projeto EKS com Terraform)

## Objetivo da Fase

Nesta fase do projeto, o objetivo é compreender como funciona a comunicação de rede dentro do Kubernetes utilizando **Amazon EKS**, incluindo:

* comunicação entre Pods
* comunicação entre Services
* exposição externa de aplicações
* integração com a VPC da AWS

Essa etapa é fundamental para permitir deploy seguro e acessível das aplicações dentro do cluster.

---

## Modelo de Rede do Kubernetes

O Kubernetes possui um modelo de rede baseado em três premissas principais:

1. Todo Pod possui um IP próprio
2. Pods conseguem se comunicar diretamente entre si
3. Containers dentro do mesmo Pod compartilham rede

No **Amazon EKS**, isso é implementado através do **AWS VPC CNI Plugin**, permitindo que os Pods recebam IPs diretamente da VPC.

Benefícios dessa abordagem:

* comunicação direta entre workloads
* menor latência
* integração nativa com Security Groups
* controle de tráfego via recursos AWS

---

## Comunicação entre Pods

Cada Pod recebe um IP único dentro da VPC.

Isso permite:

* comunicação direta entre aplicações
* comunicação entre microserviços
* comunicação entre backend e banco interno

Importante:

Pods são efêmeros.

Ou seja, seus IPs podem mudar após reinicializações ou recriações.

Por isso não devem ser acessados diretamente.

---

## Services (Service Discovery Interno)

Services fornecem um endpoint estável para acesso aos Pods.

Eles funcionam como camada de abstração entre aplicações.

Principais tipos:

### ClusterIP

Permite comunicação interna dentro do cluster.

Exemplo:

frontend → backend
backend → database

É o tipo mais comum para comunicação entre microserviços.

---

### NodePort

Expõe a aplicação através de uma porta fixa nos nodes do cluster.

Permite acesso externo básico para testes e validações.

Normalmente não utilizado em produção quando existe LoadBalancer.

---

### LoadBalancer

Cria automaticamente um **Elastic Load Balancer (ELB)** na AWS.

Permite:

* exposição pública
* acesso via internet
* balanceamento automático entre Pods

Será o principal método de exposição externa neste projeto.

---

## DNS Interno do Kubernetes

O Kubernetes possui um sistema interno de resolução de nomes.

Isso permite que aplicações se comuniquem usando nomes lógicos ao invés de IP.

Exemplo:

backend.default.svc.cluster.local

Benefícios:

* independência de IP
* facilidade de integração entre serviços
* estabilidade da comunicação interna

---

## Integração com a VPC da AWS

No Amazon EKS:

Pods recebem IPs diretamente da VPC.

Isso permite:

* comunicação com recursos AWS internos
* integração com RDS
* integração com Load Balancers
* controle via Security Groups

Essa abordagem simplifica arquitetura de rede e aumenta segurança.

---

## Exposição Externa de Aplicações

Existem duas estratégias principais dentro do EKS:

### Service Type LoadBalancer

Cria automaticamente um ELB para acesso externo.

Utilizado quando:

* aplicações precisam ser públicas
* APIs precisam ser acessadas externamente

---

### Ingress Controller

Permite exposição HTTP/HTTPS avançada.

Benefícios:

* roteamento por host
* roteamento por path
* TLS centralizado
* redução de custo com múltiplos serviços

Neste projeto será possível utilizar:

AWS Load Balancer Controller

para gerenciamento automático de Application Load Balancers.

---

## Fluxo de Rede Esperado no Projeto

Fluxo típico da aplicação:

Internet
↓
Load Balancer (AWS)
↓
Ingress Controller
↓
Service
↓
Pods

Esse modelo garante:

* escalabilidade
* alta disponibilidade
* isolamento de rede
* organização da arquitetura

---

## Resultado Esperado desta Fase

Ao final desta fase, o ambiente estará preparado para:

* comunicação interna entre microserviços
* exposição controlada de aplicações
* integração com serviços AWS
* suporte para deploy via CI/CD

Essa base será utilizada nas próximas fases para implantação das aplicações dentro do cluster EKS.
