dev-init:
	git pull
	rm -rf ./terraform/terraform.tfstate
	terraform init  

dev-plan: 
	terraform plan -var-file=./environments/dev/main.tfvars 

dev-apply: dev-init 
	aws eks update-kubeconfig --name dev --region us-east-1 || true
	terraform apply -auto-approve -var-file=./environments/dev/main.tfvars -var vault_token=$(vault_token)
	
dev-destroy: dev-init 
	aws eks update-kubeconfig --name dev --region us-east-1 || true
	terraform destroy -auto-approve -var-file=./environments/dev/main.tfvars -var vault_token=$(vault_token)

prod-init: 
	rm -f .terraform/terraform.tfstate
	terraform init

prod-plan:
	terraform plan -var-file=./environments/prod/main.tfvars

prod-apply: prod-init 
	terraform apply -var-file=./environments/prod/main.tfvars -auto-approve -var vault_token=$(vault_token)

prod-destroy: prod-init 
	terraform destroy -var-file=./environments/prod/main.tfvars -auto-approve  -var vault_token=$(vault_token)