#### ECS service creation script
##### This script:
  - creates a repository in AWS ECR,
  - Using the packer, build the docker image, pushes it to the repository.
  - creates an AWS ECS service on a given cluster
  - creates AWS ELB for this service
  - checks the availability of the service
##### Dependencies:
  - docker
  - packer
  - terraform
  - awscli
##### How-to:
1. Export credentials:
```bash
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
``` 
2. Change variables and backend files or create your own:
  - ./backends/backend-dev.json
  - ./vars/dev.tfvars
3. Change backend s3 bucket in:
  - main.tf
4. run (using existing dev config example):
```bash
make init-dev
make plan-dev
make apply-dev
```
5. Destroy all things, you created:
```bash
make destroy-dev
```
