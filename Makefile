dev-init:
	git pull
	rm -rf ./terraform/terraform.tfstate
	terraform init  
dev-plan:
	git pull
	terraform init  
	terraform plan -var-file=./environments/dev/main.tfvars 
dev-apply:
	git pull
	terraform init  
	terraform apply -auto-approve -var-file=./environments/dev/main.tfvars 
dev-destroy:
	git pull
	terraform init  
	terraform destroy -auto-approve -var-file=./environments/dev/main.tfvars 

tools-infra:
	git pull
	cd tools ; terraform init ; terraform apply -auto-approve -var-file=../environments/tools/main.tfvars