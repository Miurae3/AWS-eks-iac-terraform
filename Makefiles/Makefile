TF_DIR ?=

VPC_ID=$(shell cd $(TF_DIR) && terraform state list | grep aws_vpc | head -n 1 | xargs terraform state show | grep id | head -n1 | awk '{print $$3}')

cleanup-nat:
	if [ ! -z "$(VPC_ID)" ]; then \
	for nat in $$(aws ec2 describe-nat-gateways \
	--filter Name=vpc-id,Values=$(VPC_ID) \
	--query 'NatGateways[].NatGatewayId' \
	--output text); do \
	echo "Deleting NAT $$nat"; \
	aws ec2 delete-nat-gateway --nat-gateway-id $$nat || true ; \
	done ; fi

cleanup-endpoints:
	if [ ! -z "$(VPC_ID)" ]; then \
	for ep in $$(aws ec2 describe-vpc-endpoints \
	--filters Name=vpc-id,Values=$(VPC_ID) \
	--query 'VpcEndpoints[].VpcEndpointId' \
	--output text); do \
	echo "Deleting endpoint $$ep"; \
	aws ec2 delete-vpc-endpoints --vpc-endpoint-ids $$ep || true ; \
	done ; fi

cleanup-security-groups:
	if [ ! -z "$(VPC_ID)" ]; then \
	for sg in $$(aws ec2 describe-security-groups \
	--filters Name=vpc-id,Values=$(VPC_ID) \
	--query 'SecurityGroups[?GroupName!=`default`].GroupId' \
	--output text); do \
	echo "Deleting security group $$sg"; \
	aws ec2 delete-security-group --group-id $$sg || true ; \
	done ; fi

cleanup-eni:
	if [ ! -z "$(VPC_ID)" ]; then \
	for eni in $$(aws ec2 describe-network-interfaces \
	--filters Name=vpc-id,Values=$(VPC_ID) \
	--query 'NetworkInterfaces[].NetworkInterfaceId' \
	--output text); do \
	echo "Deleting ENI $$eni"; \
	aws ec2 delete-network-interface --network-interface-id $$eni || true ; \
	done ; fi

cleanup-eip:
	if [ ! -z "$(VPC_ID)" ]; then \
	for eip in $$(aws ec2 describe-addresses \
	--query 'Addresses[].AllocationId' \
	--output text); do \
	echo "Releasing EIP $$eip"; \
	aws ec2 release-address --allocation-id $$eip || true ; \
	done ; fi

cleanup-elb:
	for lb in $$(aws elbv2 describe-load-balancers \
	--query 'LoadBalancers[].LoadBalancerArn' \
	--output text); do \
	echo "Deleting ELB $$lb"; \
	aws elbv2 delete-load-balancer --load-balancer-arn $$lb || true ; \
	done

cleanup-elb-classic:
	for lb in $$(aws elb describe-load-balancers \
	--query 'LoadBalancerDescriptions[].LoadBalancerName' \
	--output text); do \
	echo "Deleting Classic ELB $$lb"; \
	aws elb delete-load-balancer --load-balancer-name $$lb || true ; \
	done

cleanup-route-tables:
	if [ ! -z "$(VPC_ID)" ]; then \
	for rt in $$(aws ec2 describe-route-tables \
	--filters Name=vpc-id,Values=$(VPC_ID) \
	--query 'RouteTables[?Associations[?Main!=`true`]].RouteTableId' \
	--output text); do \
	echo "Deleting route table $$rt"; \
	aws ec2 delete-route-table --route-table-id $$rt || true ; \
	done ; fi

cleanup-igw:
	if [ ! -z "$(VPC_ID)" ]; then \
	for igw in $$(aws ec2 describe-internet-gateways \
	--filters Name=attachment.vpc-id,Values=$(VPC_ID) \
	--query 'InternetGateways[].InternetGatewayId' \
	--output text); do \
	echo "Detaching IGW $$igw"; \
	aws ec2 detach-internet-gateway \
	--internet-gateway-id $$igw \
	--vpc-id $(VPC_ID) || true ; \
	echo "Deleting IGW $$igw"; \
	aws ec2 delete-internet-gateway \
	--internet-gateway-id $$igw || true ; \
	done ; fi

cleanup-k8s-sg:
	if [ ! -z "$(VPC_ID)" ]; then \
	for sg in $$(aws ec2 describe-security-groups \
	--filters Name=vpc-id,Values=$(VPC_ID) \
	--query 'SecurityGroups[?starts_with(GroupName, `k8s-`)].GroupId' \
	--output text); do \
	echo "Deleting k8s SG $$sg"; \
	aws ec2 delete-security-group --group-id $$sg || true ; \
	done ; fi

k8s-config-apply:
	aws eks update-kubeconfig \
		--name miura-cluster \
		--region sa-east-1 && \
	kubectl get nodes && \
	kubectl apply -f ../k8s/nginx-deployment.yaml && \
	kubectl get pods


destroy:
	$(MAKE) cleanup-elb-classic TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-elb TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-eip TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-nat TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-endpoints TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-eni TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-security-groups TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-route-tables TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-igw TF_DIR=$(TF_DIR)
	$(MAKE) cleanup-k8s-sg TF_DIR=$(TF_DIR)

	cd $(TF_DIR) && terraform destroy -auto-approve


destroy-dev:
	$(MAKE) destroy TF_DIR=../environments/dev

destroy-hml:
	$(MAKE) destroy TF_DIR=../environments/hml

destroy-prd:
	$(MAKE) destroy TF_DIR=../environments/prd