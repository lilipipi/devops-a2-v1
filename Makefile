ansible-run:
	cd ansible && bash run_ansible.sh

down:
	cd infra && terraform destroy --auto-approve

init:
	cd infra && terraform init

up:
	cd infra && terraform init
	cd infra &&	terraform apply --auto-approve

kube-up:
	kops create cluster --state=s3://$(shell cd infra && terraform output kops_state_bucket_name) --name=rmit.k8s.local --zones="us-east-1a,us-east-1b" --master-size=t2.medium --yes

kube-down:
	kops delete cluster --state=s3://$(shell cd infra && terraform output kops_state_bucket_name) rmit.k8s.local --yes

kube-validate:
	kops validate cluster --state=s3://$(shell cd infra && terraform output kops_state_bucket_name)

kube-restart:
	kops rolling-update cluster --state=s3://$(shell cd infra && terraform output kops_state_bucket_name)

build:
	docker build -t techtestapp:latest .