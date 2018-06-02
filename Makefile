.EXPORT_ALL_VARIABLES:
TF_VAR_aws_access_key=${AWS_ACCESS_KEY_ID}
TF_VAR_aws_secret_key=${AWS_SECRET_ACCESS_KEY}

init-%:
	terraform init -backend-config="./backends/backend-$*.json"

plan-%: 
	terraform plan -var-file="./vars/$*.tfvars"

apply-%:
	terraform apply -var-file="./vars/$*.tfvars"

destroy-%:
	terraform destroy -var-file="./vars/$*.tfvars"
