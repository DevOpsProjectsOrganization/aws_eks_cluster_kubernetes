dev-init:
	git pull
	rm -rf ./terraform/terraform.tfstate
	terraform init  
dev-plan:
	git pull
	terraform init  
	terraform plan -var-file=./environments/dev/main.tfvars 
dev-apply: dev-init 
	aws eks update-kubeconfig --name dev --region us-east-1 || true
	terraform apply -auto-approve -var-file=./environments/dev/main.tfvars 
	
dev-destroy: dev-init 
	aws eks update-kubeconfig --name dev --region us-east-1 || true
	terraform destroy -auto-approve -var-file=./environments/dev/main.tfvars 

tools-infra:
	git pull
	cd tools ; rm -rf ./terraform/terraform.tfstate; terraform init ; terraform apply -auto-approve -var-file=../environments/tools/main.tfvars

tools-destroy:
	git pull
	cd tools ; terraform init ; terraform destroy -auto-approve -var-file=../environments/tools/main.tfvars

helm-ingress:
	git pull
	cd helm-charts; aws eks update-kubeconfig --name dev; terraform apply -auto-approve -var-file=../environments/dev/main.tfvars 