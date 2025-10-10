dev-init: ## Dev Destroy
	git pull
	rm -f .terraform/terraform.tfstate
	terraform init 

dev-plan: ## Dev Plan
	terraform plan -var-file=../environments/dev/main.tfvars

dev-apply: dev-init ## Dev Apply
	aws eks update-kubeconfig --name dev || true
	terraform apply -var-file=../environments/dev/main.tfvars -auto-approve 

dev-destroy: dev-init ## Dev Destroy
	aws eks update-kubeconfig --name dev || true
	terraform destroy -var-file=../environments/dev/main.tfvars -auto-approve