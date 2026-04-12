VPC_ID=$(shell terraform state list | grep aws_vpc | head -n 1 | xargs terraform state show | grep id | head -n1 | awk '{print $$3}')

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

destroy: cleanup-nat cleanup-endpoints cleanup-security-groups cleanup-eni
	terraform destroy -auto-approve